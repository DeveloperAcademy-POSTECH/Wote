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
    case deletePost
    case getReviewDetail
    case modifyReview
    case createReview
    case deleteReview
    case subscribeReview
    case votePost
    case getReviews
    case getSearchResult
}

extension PostService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/api/posts"
        case .createPost:
            return "/api/posts"
        case .getPostDetail(let postId):
            return "/api/posts/\(postId)"
        default:
            return "/api/posts"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .getPosts(let page, let size, let visibilityScope):
            return ["page": page,
                    "size": size,
                    "visibilityScope": visibilityScope]
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
        case .getPostDetail:
            return .get
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
                let stringData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!), name: "postRequest", mimeType: "application/json")
                formData.append(stringData)
            } catch {
                print("error: \(error)")
            }
            return .uploadMultipart(formData)
        case .getPostDetail(let postId):
            return .requestParameters(parameters: ["postId": [postId]],
                                      encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createPost:
            APIConstants.headerMultiPartForm
        default:
            APIConstants.headerWithAuthorization
        }
    }
}
