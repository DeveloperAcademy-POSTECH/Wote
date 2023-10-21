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
            }
        }
        
        var url: String {
            switch self {
            case .postAuthorCode:
                return "/login/oauth2/code/apple"
            case .postNickname:
                return "/api/profiles/isValidNickname"
            case .postProfileSetting:
                return "/api/profiles"
            case .refreshToken:
                return "/api/auth/refresh"
            }
        }
    }

    func requestAPI<T: Decodable>(type: APIRequest, completion: @escaping (GeneralResponse<T>) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": type.contentType
        ]
        let parameters = type.parameters
        let url = URLConst.baseURL + type.url
        
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
