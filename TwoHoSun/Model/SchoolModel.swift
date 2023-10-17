//
//  SchoolModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import Foundation

struct SchoolModel: Identifiable {
    let id = UUID()
    let schoolName: String
    let schoolRegion: String
    let schoolType: String
}

enum SchoolType {
    case highSchool, middleSchool

    var schoolParam: String {
        switch self {
        case .highSchool:
            return "high_list"
        case .middleSchool:
            return "midd_list"
        }
    }

    var schoolType: String {
        switch self {
        case .highSchool:
            return "고등학교"
        case .middleSchool:
            return "중학교"
        }
    }
}
