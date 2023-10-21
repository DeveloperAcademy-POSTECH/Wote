//
//  WriteViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/22/23.
//

import Foundation

@Observable
final class WriteViewModel {
    var title = ""

    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }
}
