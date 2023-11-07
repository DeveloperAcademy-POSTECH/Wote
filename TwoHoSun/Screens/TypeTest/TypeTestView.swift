//
//  TypeTestView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import SwiftUI

struct TypeTestView: View {
    @State private var testProgress = 1.0

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                testProgressView
                    .padding(.top, 20)
                Spacer()
                    .frame(height: 50)
                Text("Q\(Int(testProgress)).")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(Color.accentBlue)
                    .padding(.bottom, 10)
                questionLabel(question: typeTests[Int(testProgress)-1].question,
                              highlightWord: typeTests[Int(testProgress)-1].highlight)
                Spacer()
                VStack(spacing: 16) {
                    ForEach(0..<4) { index in
                        choiceButton(order: index,
                                     content: typeTests[Int(testProgress)-1].choices[index].choice)
                    }
                }
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 16)
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

extension TypeTestView {

    private var testProgressView: some View {
        VStack(alignment: .trailing, spacing: 4) {
            ProgressView(value: testProgress, total: 7.0)
                .tint(Color.accentBlue)
            Text("0\(Int(testProgress))")
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

    private func choiceButton(order: Int, content: String) -> some View {
        Button {
            if testProgress < 7.0 {
                testProgress += 1.0
            }
        } label: {
            HStack {
                Text(String(UnicodeScalar(order + 65)!) + ". " + content)
                Spacer()
            }
        }
        .buttonStyle(CustomButtonStyle())
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 17)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.accentBlue : Color.fixedGray)
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        TypeTestView()
            .toolbar(.visible, for: .navigationBar)
    }
}
