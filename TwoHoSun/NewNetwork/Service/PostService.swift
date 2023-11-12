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
    case postVoteCreate(postId: Int, param: String)
    case getSearchResult(page: Int, size: Int, keyword: String)
    case postCreate(postCreate: PostCreateModel)
    case getDetailPost(postId: Int)
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
