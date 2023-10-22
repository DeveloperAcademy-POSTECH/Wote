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
        case postAuthorCode(authorization: String)
        case postNickname(nickname: String)
        case postProfileSetting(profile: ProfileSetting)
        case refreshToken
        case getPosts(page: Int, size: Int)
        case postVoteCreate(postId: Int, param: String)
        case postCreate(postCreate: PostCreateModel)

        var headers: HTTPHeaders {
            switch self {
            case .postAuthorCode:
                return [
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                ]
            case .postNickname:
                return [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
                ]
            case .postProfileSetting:
                return [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
                ]
            case .refreshToken:
                return [
                    "Content-Type": "application/json"
                ]
            case .getPosts:
                return [
                    "Content-Type" : "application/json",
                    "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
                    ]
            case .postVoteCreate:
                return [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
                ]
            case .postCreate:
                return [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
                ]
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
            case .postVoteCreate:
                return .post
            case .postCreate:
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
                    "userGender": model.userGender,
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
            case .postVoteCreate(_, let param):
                return [
                    "voteType": param
                ]
            case .postCreate(let postCreate):
                return [
                    "postType": postCreate.postType,
                    "title": postCreate.title,
                    "contents": postCreate.contents,
                    "image": postCreate.image,
                    "externalURL": postCreate.externalURL,
                    "postTagList": postCreate.postTagList,
                    "postCategoryType": postCreate.postCategoryType
                ]
            }
        }
        
        var encoding: ParameterEncoding {
            switch self {
            case .postAuthorCode:
                return URLEncoding.default
            case .postNickname:
                return JSONEncoding.default
            case .postProfileSetting:
                return JSONEncoding.default
            case .refreshToken:
                return JSONEncoding.default
            case .getPosts:
                return URLEncoding.queryString
            case .postVoteCreate:
                return JSONEncoding.default
            case .postCreate:
                return JSONEncoding.default
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
            case .postVoteCreate(let postId, _):
                return "/api/posts/\(postId)/votes"
            case .postCreate:
                return "/api/posts"
            }
        }
    }

    func requestAPI<T: Decodable>(type: APIRequest, completion: @escaping (GeneralResponse<T>) -> Void) {
        let headers: HTTPHeaders = type.headers
        let parameters = type.parameters
        let url = URLConst.baseURL + type.path

        AF.request(
            url,
            method: type.method,
            parameters: parameters,
            encoding: type.encoding,
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
