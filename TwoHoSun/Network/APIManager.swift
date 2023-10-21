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
        
        var contentType: String {
            switch self {
            case .postAuthorCode:
                return "application/x-www-form-urlencoded; charset=UTF-8"
            case .postNickname:
                return "application/json"
            case .postProfileSetting:
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
                return ["userNickname": nickname]
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
        let requestURL = URLConst.baseURL + "/api/auth/refresh"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: [String: String] = [
            "refreshToken": KeychainManager.shared.readToken(key: "refreshToken")!,
            "identifier": KeychainManager.shared.readToken(key: "identifier")!
        ]
        
        AF.request(requestURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .publishDecodable(type: GeneralResponse<Tokens>.self)
            .value()
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { data in
                guard let tokens = data else { return }
                KeychainManager.shared.updateToken(key: "accessToken", token: tokens.accessToken)
                KeychainManager.shared.updateToken(key: "refreshToken", token: tokens.refreshToken)
            }
            .store(in: &cancellable)
    }
}
