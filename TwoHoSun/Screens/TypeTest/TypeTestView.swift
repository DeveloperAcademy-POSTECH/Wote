//
//  TypeTestView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import SwiftUI

struct TypeTestView: View {
    @State private var testProgress = 3.0

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                testProgressView
                    .padding(.top, 20)
                Spacer(minLength: 50)
                Text("Q1.")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(Color.accentBlue)
                    .padding(.bottom, 10)
                questionLabel(question: "친구들과 쇼핑몰에 갔을 때 나는 주로···",
                              highlightWord: "쇼핑몰에 갔을 때")
                Spacer()
                VStack(spacing: 16) {
                    ForEach(0..<4) { index in
                        choiceButton(order: index,
                                     content: "이벤트홀에 가면 새로운 세일 제품들이 업데이트 되었대. 거기부터 가보자!")
                    }
                }
                Spacer(minLength: 50)
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
            Text("01")
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
        HStack {
            Text(String(UnicodeScalar(order + 65)!) + ". " + content)
            Spacer()
        }
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(.white)
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(Color.fixedGray)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        TypeTestView()
            .toolbar(.visible, for: .navigationBar)
    }
}
