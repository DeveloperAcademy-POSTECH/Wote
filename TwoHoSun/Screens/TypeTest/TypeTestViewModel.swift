//
//  TypeTestViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/9/23.
//
import Combine
import SwiftUI

final class TypeTestViewModel: ObservableObject {
    @Published var testChoices = [-1, -1, -1, -1, -1, -1, -1]
    @Published var typeScores = [ConsumerType: Int]()
    @Published var testProgressValue = 1.0
    @Published var succeedPutData = false
    @Published var userType: ConsumerType?
    private var apiManager: NewApiManager
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }

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

    func setChoice(order: Int, types: [ConsumerType]) {
        testChoices[questionNumber - 1] = order

        for type in types {
            typeScores[type, default: 0] += 1
        }
    }

    func setUserSpendType() {
        let maxScore = typeScores.values.max()!
        let maxScoreTypes = typeScores.filter { $0.value == maxScore }.map { $0.key }
        userType = maxScoreTypes.randomElement()!
    }

    func putUserSpendType() {
        setUserSpendType()
        var cancellable: AnyCancellable?
        guard let userType = userType else {return}
        cancellable = apiManager.request(.userService(.putConsumerType(consumertype: userType)), decodingType: NoData.self)
            .sink { completion in
                print(completion)
            } receiveValue: { _ in
                self.haveConsumerType = true
                self.succeedPutData.toggle()
                cancellable?.cancel()
            }
    }
}
