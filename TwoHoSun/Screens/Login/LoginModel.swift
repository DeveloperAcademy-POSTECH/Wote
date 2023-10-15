//
//  LoginModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import Foundation

struct LoginModel: Codable {
    var status: String
    var data: Tokens
}

struct Tokens: Codable {
    var accessToken: String
    var refreshToken: String
}
