//
//  PostService.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import UIKit

import Moya

enum PostService {
    case getPosts(page: Int, size: Int, visibilityScope: String)
    case createPost(post: PostCreateModel)
    case getPostDetail(postId: Int)
    case modifyPost
    case deletePost(postId: Int)
    case getReviewDetail
    case modifyReview
    case createReview
    case deleteReview
    case subscribeReview
    case votePost(postId: Int, choice: Bool)
    case getSearchResult
    case getMyPosts(page: Int, size: Int, myVoteCategoryType: String)
    case closeVote(postId: Int)
    case getReviews(visibilityScope: String,
                      reviewType: String,
                      page: Int,
                      size: Int)
}

extension PostService: TargetType {
    
    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api")!
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        case .getPostDetail(let postId):
            return "/posts/\(postId)"
        case .createPost:
            return "/posts"
        case .votePost(let postId, _):
            return "/posts/\(postId)/votes"
        case .getMyPosts:
            return "mypage/posts"
        case .deletePost(let postId):
            return "/posts/\(postId)"
        case .closeVote(let postId):
            return "/posts/\(postId)/complete"
        case .getReviews:
            return "/reviews"
        default:
            return ""
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .getPosts(let page, let size, let visibilityScope):
            return ["page": page,
                    "size": size,
                    "visibilityScope": visibilityScope]
        case .getMyPosts(let page, let size, let myVoteCategoryType):
            return ["page": page,
                    "size": size,
                    "myVoteCategoryType": myVoteCategoryType]
        case .getReviews(let visibilityScope, let reviewType, let page, let size):
            return ["visibilityScope": visibilityScope,
                    "reviewType": reviewType,
                    "page": page,
                    "size": size]
        default:
            return [:]
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPosts:
            return .get
        case .createPost:
            return .post
        case .getMyPosts:
            return .get
        case .getPostDetail:
            return .get
        case .votePost:
            return .post
        case .deletePost:
            return .delete
        case .closeVote:
            return .post
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPosts:
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
        case .createPost(let post):
            var formData: [MultipartFormData] = []
            if let data = UIImage(data: post.image ?? Data())?.jpegData(compressionQuality: 0.3) {
                let imageData = MultipartFormData(provider: .data(data), name: "imageFile", fileName: "temp.jpg", mimeType: "image/jpeg")
                formData.append(imageData)
            }
            let postData: [String: Any] = [
                "visibilityScope": post.visibilityScope.type,
                "title": post.title,
                "price": post.price ?? 0,
                "contents": post.contents ?? "",
                "externalURL": post.externalURL ?? ""
            ]
            do {
                let json = try JSONSerialization.data(withJSONObject: postData)
                let jsonString = String(data: json, encoding: .utf8)!
                let stringData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!), 
                                                   name: "postRequest",
                                                   mimeType: "application/json")
                formData.append(stringData)
            } catch {
                print("error: \(error)")
            }
            return .uploadMultipart(formData)
        case .getPostDetail(let postId):
            return .requestParameters(parameters: ["postId": postId],
                                      encoding: URLEncoding.queryString)
        case .votePost(let postId, let choice):
            return .requestCompositeParameters(bodyParameters: ["myChoice": choice],
                                               bodyEncoding: JSONEncoding.default,
                                               urlParameters: ["postId": postId])
        case .getMyPosts:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .deletePost(let postId):
            return .requestParameters(parameters: ["postId": postId],
                                      encoding: URLEncoding.queryString)
        case .closeVote(let postId):
            return .requestParameters(parameters: ["postId": postId],
                                      encoding: URLEncoding.queryString)
        case .getReviews:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createPost:
            APIConstants.headerMultiPartForm
        case .getMyPosts:
            APIConstants.headerWithAuthorization
        default:
            APIConstants.headerWithAuthorization
        }
    }
}
