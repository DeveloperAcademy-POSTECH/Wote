//
//  ErrorResponse.swift
//  TwoHoSun
//
//  Created by 235 on 11/11/23.
//

import Foundation

struct ErrorResponse: Decodable, Error {
    let status: Int
    let divisionCode: String
    let message: String
}
