//
//  PostCreateModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/22/23.
//

import Foundation
import UIKit

struct PostCreateModel: Codable {
    let visibilityScope: VisibilityScopeType
    let title: String
    let price: Int?
    let contents: String?
    let externalURL: String?
    let image: Data?
}
