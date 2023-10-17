//
//  NicknameModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/17/23.
//

import Foundation

struct NicknameResponse: Codable {
    var status: Int
    var message: String
    var data: NicknameValidation
}

struct NicknameValidation: Codable {
    var isExist: Bool
}
