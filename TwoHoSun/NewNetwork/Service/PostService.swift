//
//  PostService.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Foundation

import Moya

enum PostService {
    case getPosts(page: Int, size: Int, visibilitiyScope: String)
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
        return URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/api/posts"
        default:
            return "/api/posts"
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
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}
