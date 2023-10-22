//
//  ProfileSettingModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/18/23.
//

import Foundation

struct ProfileSetting: Codable {
    var userProfileImage: String
    var userNickname: String
    var userGender: String
    var school: SchoolModel
    var grade: Int
}

enum UserGender: String, CaseIterable {
    case boy = "남"
    case girl = "여"
}
