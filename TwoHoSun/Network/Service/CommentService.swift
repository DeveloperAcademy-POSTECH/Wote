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
    case postComment(postId: Int, contents: String)
    case deleteComments(commentId: Int)
}

extension CommentService: TargetType {
    
    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api/comments")!
    }
    
    var path: String {
        switch self {
        case .deleteComments(let commentId):
            return "/\(commentId)"
        default:
            return ""
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getComments(let postId):
            return ["postId": postId]
        case .postComment(let postId, let contents):
            return [
                "postId": postId,
                "contents": contents
            ]
        case .deleteComments(let commentId):
            return ["commentId" : commentId]
        default:
            return [:]
        }
    }
    var method: Moya.Method {
        switch self {
        case .getComments:
            return .get
        case .postComment:
            return .post
        case .deleteComments:
            return .delete
        }
    }
    
    // TODO: - 변경 필요
    var task: Moya.Task {
        switch self {
        case .getComments:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .postComment:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteComments:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}
