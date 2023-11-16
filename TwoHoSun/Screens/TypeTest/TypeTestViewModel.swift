//
//  TypeTestViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//

import Foundation

final class TypeTestViewModel: ObservableObject {
    @Published var testChoices = [-1, -1, -1, -1, -1, -1, -1]
    @Published var typeScores = [SpendTitleType: Int]()
    @Published var testProgressValue = 1.0
    @Published var userSpendType = SpendTitleType.adventurer

    var questionNumber: Int {
        Int(testProgressValue)
    }

    var isLastQuestion: Bool {
        questionNumber >= 7 ? true : false
    }

    func moveToPreviousQuestion() {
        testProgressValue -= 1.0
    }

    func moveToNextQuestion() {
        testProgressValue += 1.0
    }

    func setChoice(order: Int, types: [SpendTitleType]) {
        testChoices[questionNumber - 1] = order

        for type in types {
            typeScores[type, default: 0] += 1
        }
    }

    func setUserSpendType() -> SpendTitleType {
        let maxScore = typeScores.values.max()!
        let maxScoreTypes = typeScores.filter { $0.value == maxScore }.map { $0.key }
        return maxScoreTypes.randomElement()!
    }
}
