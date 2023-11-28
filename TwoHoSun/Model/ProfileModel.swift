//
//  UserProfileModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/20/23.
//

import Foundation

struct ProfileModel: Codable {
    var createDate: String
    var modifiedDate: String
    var lastSchoolRegisterDate: String?
    var nickname: String
    var profileImage: String?
    var consumerType: ConsumerType?
    var school: SchoolModel
    var canUpdateConsumerType: Bool
}
