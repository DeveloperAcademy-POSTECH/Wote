//
//  ReviewWriteViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import Foundation

@Observable
final class ReviewWriteViewModel {
    var title: String = ""
    var isBuy: Bool = true
    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }
}
