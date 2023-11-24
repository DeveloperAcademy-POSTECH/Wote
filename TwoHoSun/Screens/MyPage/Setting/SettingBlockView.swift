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
                    ForEach(viewModel.blockUsersList) { user in
                        BlockListCell(blockUser: user, viewModel: viewModel)
                    }
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

struct BlockListCell: View {
    @State var isBlocked: Bool = true
    var blockUser: BlockUserModel
    var viewModel: SettingViewModel
    
    var body: some View {
        HStack {
            Image("defaultProfile")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.trailing, 2)
            Text(blockUser.nickname)
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold))
            Spacer()
            Button {
                isBlocked.toggle()
            } label: {
                ZStack {
                    if isBlocked {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 103, height: 44)
                            .foregroundStyle(Color.lightBlue)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(lineWidth: 1)
                            .frame(width: 103, height: 44)
                            .foregroundStyle(Color.lightBlue)
                    }
                    Text(isBlocked ? "차단중" : "차단하기")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(isBlocked ? .white : Color.lightBlue)
                }
            }
        }
        .padding(.horizontal, 8)
        .onDisappear {
            if !isBlocked {
                viewModel.deleteBlockUser(memberId: blockUser.id)
            }
        }
        Divider()
            .foregroundStyle(Color.dividerGray)
    }
}
