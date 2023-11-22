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
    var notidummydata: [NotificationModel] = [
        NotificationModel(profileImage: "https:/www.wote.social/images/profiles/de4cf718-bd4f-4a2e-b35c-234d69c11770.png", contents: "이거사실?", time: 1, postImage: nil),
        NotificationModel(profileImage: "https:/www.wote.social/images/profiles/de4cf718-bd4f-4a2e-b35c-234d69c11770.png", contents: "ㅂ조고?", time: 2, postImage: nil),
        NotificationModel(profileImage: "https:/www.wote.social/images/profiles/de4cf718-bd4f-4a2e-b35c-234d69c11770.png", contents: "헤입덜쟈ㅐㅓ대?", time: 1, postImage: nil),
        NotificationModel(profileImage: "https:/www.wote.social/images/profiles/de4cf718-bd4f-4a2e-b35c-234d69c11770.png", contents: "럽ㄷ쟈ㅓㅐ?", time: 1, postImage: nil),
        NotificationModel(profileImage: "https:/www.wote.social/images/profiles/de4cf718-bd4f-4a2e-b35c-234d69c11770.png", contents: "ㅓ랴ㅐㅓ뱆?", time: 1, postImage: nil),
        NotificationModel(profileImage: "https:/www.wote.social/images/profiles/de4cf718-bd4f-4a2e-b35c-234d69c11770.png", contents: "러댜재러ㅐ?", time: 1, postImage: nil),
    ]

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
                ForEach(notidummydata, id: \.id) { data in
                    makenotificationCell(notiData: data)
                }
//                listHeader("오늘 알림")
//                ForEach(0..<3) { _ in
//                    notificationCell
//                }
//                Divider()
//                    .foregroundStyle(Color.dividerGray)
//                listHeader("이전 알림")
//                ForEach(0..<10) { _ in
//                    notificationCell
//                }
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
        HStack(alignment: .top, spacing: 16) {
            KFImage(URL(string: notiData.profileImage)!)
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
                Text(notiData.contents)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                Text("\(notiData.time)분 전")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.subGray5)
            }
            if Bool.random() {
                KFImage(URL(string: notiData.profileImage)!)
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
