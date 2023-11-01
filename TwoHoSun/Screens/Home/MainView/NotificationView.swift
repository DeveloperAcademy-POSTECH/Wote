//
//  NotificationView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI

struct NotificationView: View {
    
    var body: some View {
        ZStack {
            Color.background
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
        List {
            listHeader("오늘 알림")
                .listRowBackground(Color.clear)
            ForEach(0..<3) { _ in
                notificationCell
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            Divider()
                .listRowBackground(Color.clear)
            listHeader("이전 알림")
                .listRowBackground(Color.clear)
            ForEach(0..<10) { _ in
                notificationCellWithPostIcon
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .listSectionSpacing(0)
        .scrollIndicators(.hidden)
    }

    private func listHeader(_ headerName: String) -> some View {
        Text(headerName)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.gray)
            .padding(.leading, 15)
            .padding(.bottom, 10)
            .listRowSeparator(.hidden)
    }

    private var notificationCell: some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .frame(width: 46, height: 46)
                .foregroundStyle(.gray)
            VStack(alignment: .leading, spacing: 6) {
                Text("밍니님이 회원님의 게시글에 답글을\n남겼어요.")
                    .font(.system(size: 16, weight: .medium))
                Text("2분 전")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 15)
    }

    private var notificationCellWithPostIcon: some View {
        HStack(alignment: .top, spacing: 0) {
            Circle()
                .frame(width: 46, height: 46)
                .foregroundStyle(.gray)
                .padding(.trailing, 14)
            VStack(alignment: .leading) {
                Text("바부님이 회원님의 게시글에 답글을\n남겼어요.")
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Text("2분 전")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 40, height: 40)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 15)
    }
}

#Preview {
    NavigationView {
        NotificationView()
    }
}
