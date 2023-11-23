//
//  SettingBlockView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/13/23.
//

import SwiftUI

struct SettingBlockView: View {
    var viewModel: SettingViewModel

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            if viewModel.blockUsersList.isEmpty {
                Text("차단한 사용자가 없습니다.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.subGray1)
            } else {
                ScrollView {
                    Divider()
                        .foregroundStyle(Color.dividerGray)
                    blockListView
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("차단 목록")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .onAppear {
            viewModel.getBlockUsers()
        }
    }
}

extension SettingBlockView {
    private var blockListView: some View {
        ForEach(viewModel.blockUsersList) { user in
            var isToggled = false
            HStack {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 2)
                Text(user.nickname)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Button {
                    isToggled.toggle()
                } label: {
                    ZStack {
                        if isToggled {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 103, height: 44)
                                .foregroundStyle(Color.lightBlue)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(lineWidth: 1)
                                .frame(width: 103, height: 44)
                                .foregroundStyle(Color.lightBlue)
                        }
                        Text("차단중")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(isToggled ? .white : Color.lightBlue)
                    }
                }
            }
            .padding(.horizontal, 8)
            Divider()
                .foregroundStyle(Color.dividerGray)
        }
    }
}
