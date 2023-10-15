//
//  ProfileSettingsView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/16/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    @State private var nickname: String = ""
    @State private var schoolName: String = ""
    @State private var grade: String = ""

    var body: some View {
        ZStack {
            Color.white
            GeometryReader { _ in
                VStack(spacing: 0) {
                    Spacer()
                    titleLabel
                        .padding(.leading, 26)
                    Spacer()
                    profileImage
                    Spacer()
                    inputView
                        .padding(.horizontal, 26)
                    Spacer()
                    nextButton
                        .padding(.bottom, 38)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

extension ProfileSettingsView {

    private var titleLabel: some View {
        HStack {
            Text("Vote 프로필")
                .font(.system(size: 32, weight: .bold)) +
            Text("을\n")
                .font(.system(size: 32, weight: .medium)) +
            Text("설정해 주세요.")
                .font(.system(size: 32, weight: .medium))
            Spacer()
        }
    }

    private var profileImage: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .frame(width: 130, height: 130)
                .foregroundStyle(.gray)
            selectProfileButton
        }
    }

    private var selectProfileButton: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(.blue)
            Image(systemName: "camera")
                .font(.system(size: 20))
        }
        .onTapGesture {
            print("Go to Album")
        }
    }

    private var inputView: some View {
        VStack(spacing: 27) {
            nicknameInputView
            schoolInputView
            gradeInputView
        }
    }

    private var nicknameInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("닉네임")
                .font(.system(size: 16))
            HStack(spacing: 10) {
                roundedTextField(text: $nickname,
                                 iconName: nil,
                                 prompt: "한/영 10자 이내(특수문자 불가)")
                checkDuplicatedIdButton
            }
        }
    }

    private var checkDuplicatedIdButton: some View {
        Button {
            print("check is Id duplicted")
        } label: {
            Text("중복확인")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 44)
                .background(Color.black)
                .cornerRadius(10)
        }
    }

    private var schoolInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("학교")
                .font(.system(size: 16))
            roundedTextField(text: $schoolName,
                             iconName: "magnifyingglass",
                             prompt: "학교를 검색해주세요.")
        }
    }

    private var gradeInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("학년")
                .font(.system(size: 16))
            roundedTextField(text: $grade,
                             iconName: "chevron.down",
                             prompt: "학년을 선택해주세요.")
        }
    }

    private var nextButton: some View {
        Button {
            print("go to next")
        } label: {
            Text("완료")
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 361, height: 52)
                .background(Color.gray)
                .cornerRadius(10)
        }
    }

    private func roundedTextField(text: Binding<String>, iconName: String?, prompt: String) -> some View {
        HStack {
            TextField("",
                      text: text,
                      prompt: Text(prompt)
                            .font(.system(size: 12)))
                .frame(height: 44)
                .padding(EdgeInsets(top: 0, leading: 17, bottom: 0, trailing: 0))
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.system(size: 16))
                    .padding(.trailing, 18)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.black, lineWidth: 1)
        }
    }
}

#Preview {
    ProfileSettingsView()
}
