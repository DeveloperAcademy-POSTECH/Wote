//
//  SettingView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/11/23.
//

import SwiftUI

enum SettingType {
    case notification
    case block
    case announcement
    case questions
    case terms
    case appVersion
    case logOut
    
    var label: String {
        switch self {
        case .notification:
            "알림"
        case .block:
            "차단 목록"
        case .announcement:
            "공지사항"
        case .questions:
            "문의사항"
        case .terms:
            "이용약관"
        case .appVersion:
            "앱 버전"
        case .logOut:
            "로그아웃"
        }
    }
    
    var icon: String {
        switch self {
        case .notification:
            "bell"
        case .block:
            "person.crop.circle"
        case .announcement:
            "megaphone"
        case .questions:
            "questionmark"
        case .terms:
            "doc.plaintext"
        case .appVersion:
            "apple.terminal.on.rectangle"
        case .logOut:
            "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .notification:
            Color.settingYellow
        case .block:
            Color.settingRed
        case .announcement:
            Color.settingRed
        case .questions:
            Color.settingBlue
        case .terms:
            Color.settingGray
        case .appVersion:
            Color.settingGray
        case .logOut:
            Color.settingGray
        }
    }
}

struct SettingView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            List {
                settingSectionView {
                    settingLinkView(.notification) {
                        Text("알림")
                    }
                    settingLinkView(.block) {
                        Text("알림")
                    }
                }
                settingSectionView {
                    settingLinkView(.announcement) {
                        Text("알림")
                    }
                    settingLinkView(.questions) {
                        Text("알림")
                    }
                    settingLinkView(.terms) {
                        Text("알림")
                    }
                    appVersionView
                }
                settingSectionView {
                    logOutView
                }
            }
            .foregroundStyle(.white)
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.visible)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("설정")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

extension SettingView {
    private var appVersionView: some View {
        HStack {
            ZStack {
                SettingType.appVersion.color
                    .frame(width: 28, height: 28)
                    .clipShape(.rect(cornerRadius: 5))
                Image(systemName: SettingType.appVersion.icon)
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
            }
            Text(SettingType.appVersion.label)
            Spacer()
            Text("v 1.0.0")
                .foregroundStyle(Color.subGray1)
                .font(.system(size: 14))
        }
    }
    
    private var logOutView: some View {
        Button {
            print("tap")
        } label: {
            HStack {
                ZStack {
                    SettingType.logOut.color
                        .frame(width: 28, height: 28)
                        .clipShape(.rect(cornerRadius: 5))
                    Image(systemName: SettingType.logOut.icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                }
                Text(SettingType.logOut.label)
            }
        }
    }
    
    private func settingSectionView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        Section {
            content()
        }
        .listRowBackground(Color.disableGray)
        .listRowSeparatorTint(Color.gray600)
    }
    
    private func settingLinkView<Content: View>(_ type: SettingType, @ViewBuilder content: () -> Content) -> some View {
        NavigationLink {
            content()
        } label: {
            HStack {
                ZStack {
                    type.color
                        .frame(width: 28, height: 28)
                        .clipShape(.rect(cornerRadius: 5))
                    Image(systemName: type.icon)
                        .font(.system(size: 15))
                }
                Text(type.label)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    SettingView()
}
