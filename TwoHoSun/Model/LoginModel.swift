//
//  LoginModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import Foundation

struct Tokens: Codable {
    var accessToken: String
    var accessExpirationTime: Int64
    var refreshToken: String
    var refreshExpirationTime: Int64
}
