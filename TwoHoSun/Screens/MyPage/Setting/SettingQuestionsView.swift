//
//  SettingQuestionsView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/13/23.
//

import SwiftUI

@Observable
class SettingQuestionsViewModel {
    var content = ""
    var isContentValid: Bool {
        guard !content.isEmpty else { return false }
        return true
    }
    
    func submitPost() {
        print("button did tap!")
    }
}

struct SettingQuestionsView: View {
    @Bindable var viewModel: SettingQuestionsViewModel
    @FocusState private var isContentFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var placeholderText = "욕설,비방,광고 등 소비 고민과 관련없는 내용은 통보 없이 삭제될 수 있습니다."
    @Binding var isSubmited: Bool
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                Text("문의내용:")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
                textEditorView
                submitButton
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.visible)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("문의사항")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

extension SettingQuestionsView {
    private var textEditorView: some View {
        ZStack(alignment: .bottomTrailing) {
            if viewModel.content.isEmpty {
                TextEditor(text: $placeholderText)
                    .foregroundStyle(Color.placeholderGray)
                    .scrollContentBackground(.hidden)
            }
            TextEditor(text: $viewModel.content)
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .padding(.bottom, 24)
                .focused($isContentFocused)
            contentTextCountView
                .padding(.bottom, 4)
                .padding(.trailing, 4)
        }
        .font(.system(size: 14, weight: .medium))
        .frame(height: 110)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            ZStack {
                if isContentFocused {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.activeBlack)
                        .shadow(color: Color.strokeBlue.opacity(isContentFocused ? 0.25 : 0), radius: 4)
                }
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkBlue, lineWidth: 1)
            }
        )
        .onSubmit {
            dismissKeyboard()
        }
    }
    
    private var contentTextCountView: some View {
        Text("\(viewModel.content.count) ")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.subGray1)
        + Text("/ 150")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
    }
    
    private var submitButton: some View {
        Button {
            if viewModel.isContentValid {
                viewModel.submitPost()
                viewModel.content = ""
                isSubmited = true
                dismiss()
            }
        } label: {
            Text("Wote에게 전달하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.content != "" ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
        .padding(.top, 16)
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
