//
//  ProfileSettingModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/18/23.
//

import SwiftUI

struct ProfileSetting: Codable {
    var imageFile: Data?
    var nickname: String
    var school: SchoolModel?
}

enum UserGender: String, CaseIterable {
    case boy = "남"
    case girl = "여"
}
