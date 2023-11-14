//
//  CommentService.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Foundation

import Moya

enum CommentService {
    case getComments(postId: Int)
    case postComments(postComment: CommentPostModel)
    case deleteComments(postId: Int, commentId: Int)
}

extension CommentService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getComments(let postId):
            return "/api/posts/\(postId)/comments"
        case .postComments(let postComment):
            return "/api/posts/\(postComment.postId)/comments"
        case .deleteComments(let postId, let commentId):
            return "/api/posts/\(postId)/comments/\(commentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getComments:
            return .get
        case .postComments:
            return .post
        case .deleteComments:
            return .delete
        }
    }
    
    // TODO: - 변경 필요
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}
