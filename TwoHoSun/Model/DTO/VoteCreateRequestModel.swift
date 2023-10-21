//
//  VoteCreateRequestModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/21/23.
//

import SwiftUI

struct VoteCreateRequest: Codable {
    let votetype: VoteType
}

enum VoteType: String, Codable {
    case agree = "AGREE"
    case disagree = "DISAGREE"

    var title: String {
        switch self {
        case .agree:
            return "산다"
        case .disagree:
            return "안산다"
        }
    }

    var color: Color {
        switch self {
        case .agree:
            return .orange
        case .disagree:
            return .pink
        }
    }
}
