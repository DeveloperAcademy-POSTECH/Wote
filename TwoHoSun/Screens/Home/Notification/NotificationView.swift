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
//    @Environment(\.managedObjectContext) var managedObjContext
//    @FetchRequest(entity: NotificationModel.entity(),
//                  sortDescriptors: [NSSortDescriptor(keyPath: \NotificationModel.date, ascending: true)]) var datas: FetchedResults<NotificationModel>
    @ObservedObject var viewModel: DataController
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            notificationList
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
    private var notificationList: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !viewModel.todayDatas.isEmpty {
                    listHeader("오늘 알림")
                    ForEach(viewModel.todayDatas) { data in
                        makenotificationCell(notiData: data)
                    }
                }
                if !viewModel.previousDatas.isEmpty {
                    Divider()
                        .foregroundStyle(Color.dividerGray)
                    listHeader("이전 알림")
                    ForEach(viewModel.previousDatas) {data in
                        makenotificationCell(notiData: data)
                    }
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
