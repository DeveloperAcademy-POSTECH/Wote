//
//  NewAPIManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/9/23.
//

import SwiftUI

import Moya

enum APIService {
    case postAuthorCode(authorization: String)
    case postNickname(nickname: String)
    case postProfileSetting(profile: ProfileSetting)
    case refreshToken
    case getPosts(page: Int, size: Int)
    case postVoteCreate(postId: Int, param: String)
    case getSearchResult(page: Int, size: Int, keyword: String)
    case postCreate(postCreate: PostCreateModel)
    case getComments(postId: Int)
    case postComments(commentPost: CommentPostModel)
    case deleteComments(postId: Int, commentId: Int)
    case getDetailPost(postId: Int)

}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: URLConst.baseURL)!
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
        case .getComments(let postId):
            return "/api/posts/\(postId)/comments"
        case .postComments(let postComment):
            return "/api/posts/\(postComment.postId)/comments"
        case .deleteComments(let postId, let commentId):
            return "/api/posts/\(postId)/comments/\(commentId)"
        case .getSearchResult:
            return "/api/posts/search"
        case .getDetailPost(let postId):
            return "/api/posts/\(postId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postAuthorCode:
            return .post
        case .postNickname:
            return .post
        case .postProfileSetting:
            return .post
        case .refreshToken:
            return .post
        case .postVoteCreate:
            return .post
        case .postComments:
            return .post
        case .deleteComments:
            return .delete
        case .postCreate:
            return .post
        default:
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
                "nickname": nickname
            ]
        case .postProfileSetting(let model):
            return [
                "nickname": model.userNickname,
                "school": [
                    "schoolName": model.school.schoolName,
                    "schoolRegion": model.school.schoolRegion
                ]
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
        case .getComments(let postId):
            return [
                "postId": postId
            ]
        case .postComments(let postComment):
            var parameters: [String: Any] = ["content": postComment.content]
            if postComment.parentId > 0 {
                parameters["parentId"] = postComment.parentId
            }
            return parameters
        case .deleteComments:
            return [:]
        case .getSearchResult(let page, let size, let keyword):
            return [
                "page" : page,
                "size" : size,
                "keyword": keyword
            ]
        case .getDetailPost(let postId):
            return [
                "postId": postId
            ]
        }
    }

    var task: Moya.Task {
        switch self {
        case .postAuthorCode:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getPosts:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getComments:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getDetailPost:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .getSearchResult:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .deleteComments:
            return .requestPlain
        case .postProfileSetting(let profile):
            var formData: [MultipartFormData] = []
            if let profileImage = profile.userProfileImage, let data = UIImage(data: profileImage)?.jpegData(compressionQuality: 0.3) {
                let imageData = MultipartFormData(provider: .data(data), name: "imageFile", fileName: "temp.jpg", mimeType: "image/jpeg")
                formData.append(imageData)
            }
            let json = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            let jsonString = String(data: json, encoding: .utf8)!
            let stringData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!), name: "profileRequest", mimeType: "application/json")
            formData.append(stringData)
            print(formData)
            return .uploadMultipart(formData)
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        switch self {
        case .postAuthorCode:
            return APIConstants.headerXform
        case .refreshToken:
            return APIConstants.headerWithOutToken
        case .postProfileSetting:
            return APIConstants.headerMultiPartForm
        default:
            return APIConstants.headerWithAuthorization
        }
    }
}
