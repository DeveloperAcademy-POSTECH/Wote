//
//  PostEnums.swift
//  TwoHoSun
//
//  Created by 김민 on 11/17/23.
//

import Foundation

enum PostStatus: String, Codable, CaseIterable {
    case active = "ACTIVE"
    case closed = "CLOSED"
    case review = "REVIEW"

    var filterTitle: String {
        switch self {
        case .active:
            return "진행중인 투표"
        case .closed:
            return "종료된 투표"
        case .review:
            return "후기"
        }
    }
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
            return "우리 학교 투표"
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
