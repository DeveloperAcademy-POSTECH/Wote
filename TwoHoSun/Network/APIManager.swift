//
//  APIManager.swift
//  TwoHoSun
//
//  Created by 관식 on 10/19/23.
//

import Combine
import Foundation

import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    private var cancellable: Set<AnyCancellable> = []
    
    enum HttpMethod {
        case get, post, put, delete
    }
    
    enum APIRequest {
        case postAuthorCode(String)
        case postNickname(String)
        case postProfileSetting(ProfileSetting)
        case refreshToken
        case getPosts(Int, Int)

        var contentType: String {
            switch self {
            case .postAuthorCode:
                return "application/x-www-form-urlencoded; charset=UTF-8"
            case .postNickname:
                return "application/json"
            case .postProfileSetting:
                return "application/json"
            case .refreshToken:
                return "application/json"
            case .getPosts:
                return "application/json"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .postAuthorCode:
                return .post
            case .postNickname:
                return .post
            case .postProfileSetting:
                return .post
            case .refreshToken:
                return .post
            case .getPosts:
                return .get
            }
        }
        
        var parameters: [String: Any] {
            switch self {
            case .postAuthorCode(let auth):
                return [
                    "state": "test",
                    "code": auth
                ]
            case .postNickname(let nickname):
                return [
                    "userNickname": nickname
                ]
            case .postProfileSetting(let model):
                return [
                    "userProfileImage": model.userProfileImage,
                    "userNickname": model.userNickname,
                    "school": [
                        "schoolName": model.school.schoolName,
                        "schoolRegion": model.school.schoolRegion,
                        "schoolType": model.school.schoolType
                    ],
                    "grade": model.grade
                ]
            case .refreshToken:
                return [
                    "refreshToken": KeychainManager.shared.readToken(key: "refreshToken")!,
                    "identifier": KeychainManager.shared.readToken(key: "identifier")!
                ]
            case .getPosts(let page, let size):
                return [
                    "page" : page,
                    "size" : size
                ]
            }
        }
        
        var path: String {
            switch self {
            case .postAuthorCode:
                return "/login/oauth2/code/apple"
            case .postNickname:
                return "/api/profiles/isValidNickname"
            case .postProfileSetting:
                return "/api/profiles"
            case .refreshToken:
                return "/api/auth/refresh"
            case .getPosts:
                return "/api/posts"
            }
        }
    }

    func requestAPI<T: Decodable>(type: APIRequest, completion: @escaping (GeneralResponse<T>) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": type.contentType,
            "Authorization": "eyJwcm92aWRlcklkIjoiMDAwNjA4LmFjNGRlN2M2YTU3MzRmMThiMGIzZDUzNmFmNjQ0YjI4LjE3MjAiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJwcm92aWRlcklkIiwidHlwZSI6ImFjY2VzcyIsImlhdCI6MTY5Nzg4ODQ2MywiZXhwIjoxNjk4NDkzMjYzfQ.B-M9KOEvTm25RuZSnPWihkJ8M6N-RWosgIlDlxfZpdo"
        ]
        let parameters = type.parameters
        let url = URLConst.baseURL + type.path
        
        AF.request(
            url,
            method: type.method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .publishDecodable(type: GeneralResponse<T>.self)
        .value()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        }, receiveValue: completion )
        .store(in: &cancellable)
    }
    
    func refreshAllTokens() {
        self.requestAPI(type: .refreshToken) { (response: GeneralResponse<Tokens>) in
            guard let data = response.data else { return }
            KeychainManager.shared.updateToken(key: "accessToken", token: data.accessToken)
            KeychainManager.shared.updateToken(key: "refreshToken", token: data.refreshToken)
        }
    }
}
