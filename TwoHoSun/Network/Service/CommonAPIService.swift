//
//  CommonAPIService.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Combine
import SwiftUI

import Moya

enum CommonAPIService {
    case userService(UserService)
    case postService(PostService)
    case commentService(CommentService)
}

extension CommonAPIService: TargetType {
    var baseURL: URL {
        switch self {
        case .userService(let userAPI):
            return userAPI.baseURL
        case .postService(let postAPI):
            return postAPI.baseURL
        case .commentService(let commentAPI):
            return commentAPI.baseURL
        }
    }

    var path: String {
        switch self {
        case .userService(let userAPI):
            return userAPI.path
        case .postService(let postAPI):
            return postAPI.path
        case .commentService(let commentAPI):
            return commentAPI.path
        }
    }

    var method: Moya.Method {
        switch self {
        case .userService(let userAPI):
            return userAPI.method
        case .postService(let postAPI):
            return postAPI.method
        case .commentService(let commentAPI):
            return commentAPI.method
        }
    }

    var task: Task {
        switch self {
        case .userService(let userAPI):
            return userAPI.task
        case .postService(let postAPI):
            return postAPI.task
        case .commentService(let commentAPI):
            return commentAPI.task
        }
    }

    var headers: [String : String]? {
        switch self {
        case .userService(let userAPI):
            return userAPI.headers
        case .postService(let postAPI):
            return postAPI.headers
        case .commentService(let commentAPI):
            return commentAPI.headers
        }
    }
}
