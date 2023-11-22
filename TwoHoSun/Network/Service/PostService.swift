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
    case createReview(postId: Int, review: ReviewCreateModel)
    case deleteReview
    case subscribeReview
    case votePost(postId: Int, choice: Bool)
    case getSearchResult(postStatus: PostStatus, visibilityScopeType: VisibilityScopeType, page: Int, size: Int, keyword: String)
    case getMyPosts(page: Int, size: Int, myVoteCategoryType: String)
    case getMyReviews(page: Int, size: Int, myReviewCategoryType: String)
    case closeVote(postId: Int)
    case getReviews(visibilityScope: String, reviewType: String, page: Int, size: Int)
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
        case .getSearchResult:
            return "/search"
        case .getMyReviews:
            return "mypage/reviews"
        case .deletePost(let postId):
            return "/posts/\(postId)"
        case .closeVote(let postId):
            return "/posts/\(postId)/complete"
        case .getReviews:
            return "/reviews"
        case .createReview(let postId, _):
            return "/posts/\(postId)/reviews"
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
        case .getSearchResult(let postStatus, let visibilityScopeType, let page, let size, let keyword):
            return [
                "postStatus": postStatus.rawValue,
                "visibilityScope": visibilityScopeType.type,
                "page": page,
                "size": size,
                "keyword": keyword
            ]
        case .getReviews(let visibilityScope, let reviewType, let page, let size):
            return ["visibilityScope": visibilityScope,
                    "reviewType": reviewType,
                    "page": page,
                    "size": size]
        case .getMyReviews(let page, let size, let myReviewCategoryType):
            return ["page": page,
                    "size": size,
                    "visibilityScope": myReviewCategoryType]
        case .createReview(let postId, _):
            return ["postId": postId]
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
        case .getMyReviews:
            return .get
        case .createReview:
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
        case .getSearchResult:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .deletePost(let postId):
            return .requestParameters(parameters: ["postId": postId],
                                      encoding: URLEncoding.queryString)
        case .closeVote(let postId):
            return .requestParameters(parameters: ["postId": postId],
                                      encoding: URLEncoding.queryString)
        case .getReviews:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getMyReviews:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .createReview(_, let review):
            var formData: [MultipartFormData] = []
            if let data = UIImage(data: review.image ?? Data())?.jpegData(compressionQuality: 0.3) {
                let imageData = MultipartFormData(provider: .data(data), name: "imageFile", fileName: "temp.jpg", mimeType: "image/jpeg")
                formData.append(imageData)
            }
            let postData: [String: Any] = [
                "title": review.title,
                "contents": review.contents ?? "",
                "price": review.price ?? 0,
                "isPurchased": review.isPurchased
            ]
            do {
                let json = try JSONSerialization.data(withJSONObject: postData)
                let jsonString = String(data: json, encoding: .utf8)!
                let stringData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!),
                                                   name: "reviewRequest",
                                                   mimeType: "application/json")
                formData.append(stringData)
            } catch {
                print("error: \(error)")
            }
            return .uploadMultipart(formData)
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
        case .getMyReviews:
            APIConstants.headerWithAuthorization
        case .createReview:
            APIConstants.headerMultiPartForm
        default:
            APIConstants.headerWithAuthorization
        }
    }
}
