//
//  NotificationView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI

import Kingfisher

struct NotificationView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            notificationList
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("알림")
                    .foregroundStyle(.white)
            }
        }
    }
}

extension NotificationView {
    private var notificationList: some View {
        ScrollView {
            VStack(alignment: .leading) {
                listHeader("오늘 알림")
                ForEach(0..<3) { _ in
                    notificationCell
                }
                Divider()
                    .foregroundStyle(Color.dividerGray)
                    .listRowBackground(Color.clear)
                listHeader("이전 알림")
                ForEach(0..<10) { _ in
                    notificationCell
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
    }

    private func listHeader(_ headerName: String) -> some View {
        Text(headerName)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.white)
            .padding(.top, 16)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }

    private var notificationCell: some View {
        HStack(alignment: .top, spacing: 16) {
            KFImage(URL(string: "https://picsum.photos/100")!)
                .placeholder {
                    ProgressView()
                        .preferredColorScheme(.dark)
                }
                .onFailure { error in
                    print(error.localizedDescription)
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 46, height: 46)
                .clipShape(.circle)
            VStack(alignment: .leading, spacing: 6) {
                Text("선호님이 회원님의 게시글에 답글을 남겼어요.")
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                Text("2분 전")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.subGray5)
            }
            if Bool.random() {
                KFImage(URL(string: "https://picsum.photos/100")!)
                    .placeholder {
                        ProgressView()
                            .preferredColorScheme(.dark)
                    }
                    .onFailure { error in
                        print(error.localizedDescription)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(.rect(cornerRadius: 8))
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    NavigationView {
        NotificationView()
    }
}
