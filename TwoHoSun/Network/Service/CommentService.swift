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
    case postReply(commentId: Int, contents: String)
}

extension CommentService: TargetType {
    
    var baseURL: URL {
        return URL(string: "\(URLConst.baseURL)/api/comments")!
    }
    
    var path: String {
        switch self {
        case .deleteComments(let commentId):
            return "/\(commentId)"
        case .postReply(let commentId, _):
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
        case .postReply(_, let contents):
            return ["contents" : contents]
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
        case .postReply:
            return .post
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
            return .requestPlain
        case .postReply:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return APIConstants.headerWithAuthorization
    }
}
