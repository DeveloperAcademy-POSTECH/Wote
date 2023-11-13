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
    @State private var sliderValue: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            List {
                Section {
                    Toggle(isOn: $isNotificationOn) {
                        Text("알림")
                    }
                    HStack {
                        Image(systemName: "speaker.fill")
                        Slider(value: $sliderValue, in: 0...100, step: 1)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    .foregroundStyle(Color.settingGray)
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
    SettingNotificationView()
}
