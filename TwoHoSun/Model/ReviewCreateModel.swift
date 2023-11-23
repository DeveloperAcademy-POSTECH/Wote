//
//  ReviewCreateModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/21/23.
//

import Foundation

struct ReviewCreateModel: Codable {
    let title: String
    let contents: String?
    let price: Int?
    let isPurchased: Bool
    let image: Data?
}
