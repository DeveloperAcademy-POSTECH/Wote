//
//  PostEnums.swift
//  TwoHoSun
//
//  Created by 김민 on 11/17/23.
//

import Foundation

enum PostStatus: String, Codable {
    case active = "ACTIVE"
    case closed = "CLOSED"
    case review = "REVIEW"
}

enum VisibilityScopeType: String, Codable {
    case all = "ALL"
    case global = "GLOBAL"
    case school = "SCHOOL"

    var title: String {
        switch self {
        case .all:
            return "전체"
        case .global:
            return "전국 투표"
        case .school:
            return "OO고등학교 투표"
        }
    }
}
