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

enum VisibilityScopeType: Codable {
    case all, global, school

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

    var type: String {
        switch self {
        case .all:
            return "ALL"
        case .global:
            return "GLOBAL"
        case .school:
            return "SCHOOL"
        }
    }
}
