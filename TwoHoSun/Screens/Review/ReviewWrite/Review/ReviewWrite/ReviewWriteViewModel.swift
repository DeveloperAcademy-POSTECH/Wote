//
//  ReviewWriteViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import Foundation

@Observable
final class ReviewWriteViewModel {
    var isBuy: Bool = true
    var title: String = ""
    var price: String = ""
    var content = ""
    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }
}
