//
//  NotificationView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI

import Kingfisher

struct NotificationView: View {
    @Environment(AppLoginState.self) private var stateManager
    @ObservedObject var viewModel: DataController

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            notificationList
                .background(Color.background)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("알림")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

extension NotificationView {
    @ViewBuilder
    private var notificationList: some View {
        List {
            if !viewModel.todayDatas.isEmpty {
                makeNotificationSection(title: "오늘 알림", data: viewModel.todayDatas.reversed(), isRecentData: true)
            }
            if !viewModel.previousDatas.isEmpty {
                makeNotificationSection(title: "이전 알림", data: viewModel.previousDatas.reversed(), isRecentData: false)
            }
        }
        .listStyle(DefaultListStyle())
        .scrollContentBackground(.hidden)
    }

    private func listHeader(_ headerName: String) -> some View {
        Text(headerName)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.white)
            .background(Color.background)
    }

    func makeNotificationSection(title: String, data: [NotificationModel], isRecentData: Bool) -> some View {
        Section(header: listHeader(title)) {
            ForEach(data) { dataItem in
                Button {
                    stateManager.serviceRoot.navigationManager.navigate(
                        .detailView(postId: Int(dataItem.postId), dirrectComments: true))
                } label: {
                    makenotificationCell(notiData: dataItem)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(isRecentData ? EdgeInsets() : EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowBackground(Color.background)
            }
            .onDelete { index in
                let reversedIndex = data.count - 1 - index.first!
                viewModel.deleteData(indexSet: IndexSet(integer: reversedIndex), recentData: isRecentData)
            }
        }
        .listRowBackground(Color.background)
        .background(Color.background)
        .listRowInsets(EdgeInsets())
    }
    
    func makenotificationCell(notiData: NotificationModel) -> some View {
        var diffrentTime: (String, Int) {
            return (notiData.date?.differenceCurrentTime())!
        }
        return HStack(alignment: .top, spacing: 16) {
            if let profileImage = notiData.authorProfile {
                KFImage(URL(string: profileImage)!)
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
            } else {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 46, height: 46)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(notiData.body!)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                Text("\(diffrentTime.1)\(diffrentTime.0)")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.subGray5)
            }
            if let postImage = notiData.postImage {
                KFImage(URL(string: postImage)!)
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
