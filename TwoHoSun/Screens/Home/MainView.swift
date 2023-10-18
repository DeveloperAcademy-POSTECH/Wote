//
//  HomeView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/16/23.
//

import SwiftUI

struct MainView: View {
    @Binding var navigationPath: [Route]
    var body: some View {
        VStack {
            HStack {
                Text("HI")
            }
            HStack {
                Text("ii")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("splash")
                    .resizable()
                    .frame(width: 120,height: 36)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 16) {
                    noticeButton
                    searchButton
                }
            }
        }

    }
}

extension MainView {
    private var noticeButton: some View {
        Button(action: {}, label: {
            Image(systemName: "bell.fill")
        })
    }
    private var searchButton: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Image(systemName: "magnifyingglass")
        })
    }
}
#Preview {
    NavigationView {
        MainView(navigationPath: .constant([.mainView]))
    }
}


