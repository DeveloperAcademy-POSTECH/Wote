//
//  SettingBlockView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/13/23.
//

import SwiftUI

// MARK: 임시 데이터 모델
struct BlockModel: Hashable, Identifiable {
    let id: UUID = UUID()
    let userName: String
    var isBlock: Bool
}

struct SettingBlockView: View {
    
    // MARK: 임시 데이터
    @State private var blockList: [BlockModel] = [
        BlockModel(userName: "얄루", isBlock: true),
        BlockModel(userName: "얄루", isBlock: true),
        BlockModel(userName: "얄루", isBlock: true)
    ]

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            if blockList.isEmpty {
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
                Text("알림")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

extension SettingBlockView {
    private var blockListView: some View {
        ForEach($blockList) { $user in
            HStack {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.trailing, 2)
                Text(user.userName)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Button {
                    user.isBlock.toggle()
                } label: {
                    ZStack {
                        if user.isBlock {
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
                            .foregroundStyle(user.isBlock ? .white : Color.lightBlue)
                    }
                }
            }
            .padding(.horizontal, 8)
            Divider()
                .foregroundStyle(Color.dividerGray)
        }
    }
}

#Preview {
    SettingBlockView()
}
