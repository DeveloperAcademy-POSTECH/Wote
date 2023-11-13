//
//  SettingNotificationView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/13/23.
//

import SwiftUI
import UserNotifications

struct SettingNotificationView: View {
    
    @State private var isNotificationOn: Bool = false
    @State private var isMarketingOn: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            List {
                Section {
                    Toggle(isOn: $isNotificationOn) {
                        Text("알림")
                    }
                    Toggle(isOn: $isMarketingOn) {
                        Text("마케팅 수신 알림")
                    }
                }
                .foregroundStyle(.white)
                .listRowBackground(Color.disableGray)
                .listRowSeparatorTint(Color.gray600)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.visible)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("알림")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingNotificationView()
    }
}
