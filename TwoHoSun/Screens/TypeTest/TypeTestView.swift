//
//  TypeTestView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import SwiftUI

struct TypeTestView: View {
    @State private var isTypeTestResultViewShown = false
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: TypeTestViewModel
    @State var userSpendType: SpendTitleType?

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                testProgressView
                    .padding(.top, 20)
                Spacer()
                    .frame(height: 50)
                Text("Q\(viewModel.questionNumber).")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(Color.accentBlue)
                    .padding(.bottom, 10)
                questionLabel(question: typeTests[viewModel.questionNumber-1].question,
                              highlightWord: typeTests[viewModel.questionNumber-1].highlight)
                Spacer()
                VStack(spacing: 16) {
                    ForEach(0..<4) { index in
                        choiceButton(order: index,
                                     choiceModel: typeTests[viewModel.questionNumber-1].choices[index])
                    }
                }
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .navigationDestination(isPresented: $isTypeTestResultViewShown) {
            if let userSpendType = userSpendType {
                TypeTestResultView(spendType: userSpendType)
            }
        }
    }
}

extension TypeTestView {

    private var backButton: some View {
        Button {
            if viewModel.questionNumber > 1 {
                viewModel.moveToPreviousQuestion()
            } else {
                dismiss()
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                Text(viewModel.questionNumber > 1 ? "이전" : "소비성향 테스트")
                    .font(.system(size: 16))
            }
            .foregroundStyle(Color.accentBlue)
        }
    }

    private var testProgressView: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ProgressView(value: viewModel.testProgressValue, total: 7.0)
                .tint(Color.accentBlue)
                .animation(.easeIn, value: viewModel.testProgressValue)
            Text("0\(viewModel.questionNumber)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.accentBlue)
            + Text("/07")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.darkGray)
        }
    }

    private func questionLabel(question: String, highlightWord: String) -> some View {
        let range = question.range(of: highlightWord)!
        let before = question[..<range.lowerBound]
        let highlighted = question[range]
        let after = question[range.upperBound...]

        return HStack(spacing: 0) {
            standarWordLabel(String(before))
            highLightedWordLabel(String(highlighted))
            standarWordLabel(String(after))
        }
    }

    private func standarWordLabel(_ word: String) -> some View {
        Text(word)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(.white)
    }

    private func highLightedWordLabel(_ word: String) -> some View {
        standarWordLabel(word)
            .background(
                Color.accentBlue
                    .padding(.top, 12)
            )
    }

    private func choiceButton(order: Int, choiceModel: ChoiceModel) -> some View {
        Button {
            withAnimation(nil) {
                viewModel.setChoice(order: order, types: choiceModel.types)

                guard viewModel.isLastQuestion else {
                    viewModel.moveToNextQuestion()
                    return
                }

                isTypeTestResultViewShown = true
                userSpendType = viewModel.setUserSpendType()
            }
        } label: {
            HStack {
                Text(String(UnicodeScalar(order + 65)!) + ". " + choiceModel.choice)
                Spacer()
            }
        }
        .buttonStyle(ChoiceButtonStyle(testChoices: $viewModel.testChoices,
                                       testProgress: $viewModel.testProgressValue,
                                       order: order))
    }
}

struct ChoiceButtonStyle: ButtonStyle {
    @Binding var testChoices: [Int]
    @Binding var testProgress: Double
    var order: Int

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            .padding(.vertical, 17)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if configuration.isPressed || testChoices[Int(testProgress) - 1] == order {
                        Color.accentBlue
                    } else {
                        Color.fixedGray
                    }
                }
            )
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        TypeTestView(viewModel: TypeTestViewModel())
            .toolbar(.visible, for: .navigationBar)
    }
}
