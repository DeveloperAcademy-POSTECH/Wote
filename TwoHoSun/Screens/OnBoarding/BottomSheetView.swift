//
//  BottomSheetView.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI

struct BottomSheetView: View {
    @Environment(\.dismiss) var dismiss
    @State private var checked: [Bool]  = [false, false, false]
    @State private var showAlert = false
    @Binding var goProfileView: Bool
    private var allChecked: Bool {
        checked.allSatisfy { $0 }
    }

    var body: some View {
        ZStack {
            Color.disableGray
            VStack(spacing: 24) {
                ZStack {
                    Text("약관 동의")
                        .font(.system(size: 20, weight: .bold))
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                        })
                        Spacer()
                    }
                }
                .foregroundStyle(.white)
                allCheckBoxView
                    .padding(.vertical, 8)
                ForEach(0..<3) { index in
                    if let agreeType = TermAgreeType.fromRawValue(index) {
                        CheckBoxView(checked: $checked[index], agreeType: agreeType)
                    }
                }
                .padding(.horizontal, 12)
                Spacer()
                nextButtonView
            }
            .padding(.top, 56)
            .padding(.bottom, 46)
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("이용약관에 동의를 해주세요"), dismissButton: .default(Text("확인")))
        }
    }

    struct CheckBoxView: View {
        @Binding var checked: Bool
        @State private var isTermShown = false
        @State var agreeType: TermAgreeType

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: checked ? "checkmark.square" : "square")
                            .foregroundStyle(checked ? Color.checkColor : Color.whiteGray)
                            .contentShape(Rectangle())
                        Text(agreeType.text)
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .lineLimit(1)
                            .padding(.leading, 4)
                        Text(agreeType.isRequired ? "(필수)" : "(선택)")
                            .foregroundStyle(agreeType.isRequired ? .red : Color.subGray4)
                            .font(.system(size: 14))
                    }
                    .onTapGesture {
                        self.checked.toggle()
                    }
                    Spacer()
                    Button {
                        isTermShown.toggle()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.subGray3)
                    }
                }
                if agreeType.rawValue == 2 {
                    Text("마케팅 정보는 문자, E-mail, Push알림으로 받을 수 있으면\n동의 여부는 알림설정에서 확인 가능합니다.")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.subGray3)
                        .fixedSize()
                        .lineSpacing(2)
                        .padding(.leading, 28)
                }
            }
            .fullScreenCover(isPresented: $isTermShown) {
                LinkView(externalURL: agreeType.termURL)
            }
        }
    }
}

extension BottomSheetView {
    private var nextButtonView: some View {
        Button(action: {
            if !checked[0] || !checked[1] {
                showAlert = true
            } else {
                goProfileView = true
                dismiss()
            }
        }, label: {
            Text("동의하고 계속하기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(checked[0] && checked[1] ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(checked[0] && checked[1] ? Color.lightBlue : Color.whiteGray)
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .buttonStyle(PlainButtonStyle())
    }

    private var allCheckBoxView: some View {
        Button {
            checked = Array(repeating: !allChecked, count: checked.count)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.subGray1, lineWidth: 1)
                HStack(spacing: 4) {
                    Image(systemName: allChecked ? "checkmark.square" : "square")
                        .font(.system(size: 24))
                        .foregroundColor(allChecked ? Color.checkColor : Color.whiteGray)
                    Text("전체 동의")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Text("(선택 포함)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.subGray2)
                    Spacer()
                }
                .padding(.leading, 12)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 58, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        BottomSheetView(goProfileView: .constant(false))
    }
}
