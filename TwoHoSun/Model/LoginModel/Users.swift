//
//  LoginModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import Foundation

struct Users: Codable {
    var consumerTypeExist: Bool?
    var jwtToken : Tokens
}

struct Tokens: Codable {
    var accessToken: String
    var refreshToken: String
}
