//
//  NotificationView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI

struct NotificationView: View {

    var body: some View {
        ZStack{
            Color.white
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

extension NotificationView {

    private var backButton: some View {
        Button {

        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationView()
    }
}
