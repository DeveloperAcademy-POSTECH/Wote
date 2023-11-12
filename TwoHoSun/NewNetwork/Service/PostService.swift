//
//  PostService.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Foundation

import Moya

enum PostService {
    case getPosts(page: Int, size: Int)
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
        return "/api/posts/"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}
