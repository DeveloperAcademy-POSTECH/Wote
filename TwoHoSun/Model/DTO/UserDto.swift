//
//  UserDto.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Foundation

struct AuthCodeRequestDto: Codable {
    let state: String
    let code: String
}

struct NicknameRequestDto: Codable {
    let nickname: String
}
