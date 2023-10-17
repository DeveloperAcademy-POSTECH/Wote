//
//  ProfileSettingsViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/18/23.
//

import Foundation

@Observable
final class SettingsViewModel {
    var nickname = ""
    var nicknameInvalidType = NicknameValidationType.empty

    let forbiddenWord = ["ㅅㅂ", "똥"]

    func isNicknameLengthValid(_ text: String) -> Bool {
        let pattern = #"^.{1,10}$"#
        if let range = text.range(of: pattern, options: .regularExpression) {
            return text.distance(from: range.lowerBound, to: range.upperBound) == text.count
        }
        return false
    }

    func isNicknameIncludeForbiddenWord(_ text: String) -> Bool {
        for word in forbiddenWord where text.contains(word) {
            return true
        }
        return false
    }

    func checkNicknameValidation(_ text: String) {
        if text.isEmpty {
            nicknameInvalidType = .empty
        } else if !isNicknameLengthValid(text) {
            nicknameInvalidType = .length
        } else if isNicknameIncludeForbiddenWord(text) {
            nicknameInvalidType = .forbiddenWord
        } else {
            // TODO: - 중복 확인까지 완료되면 valid 상태로 변경
            nicknameInvalidType = .valid
        }
    }
}
