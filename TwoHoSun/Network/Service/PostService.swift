//
//  PostService.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Foundation

import Moya

enum PostService {
    case getPosts(page: Int, size: Int, visibilityScope: String)
    case createPost
    case getPostDetail
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
        return URL(string: "\(URLConst.baseURL)/api/posts")!
    }
    
    var path: String {
        switch self {
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
        default:
            return [:]
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPosts:
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
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}
