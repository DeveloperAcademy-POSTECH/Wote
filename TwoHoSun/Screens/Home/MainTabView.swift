//
//  TabView.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI

struct MainTabView : View {
    @State private var selection = 0
//    @Binding var path: [Route]
    var body: some View {
            TabView(selection: $selection) {
                MainView()
                    .tabItem {
                        iconImage("1.square.fill")
                    }
                    .tag(0)

                Text("아직 안만듬333")
                    .tabItem {
                        iconImage("heart.fill")
                    }
                    .tag(1)

                Text("아직 안만듬222")
                    .tabItem {
                        iconImage("2.square.fill")
                    }
                    .tag(2)

                Text("아직 안만듬")
                    .tabItem {
                        iconImage("3.square.fill")
                    }
                    .tag(3)
            }
//            .navigationBarBackButtonHidden()
    }
}

extension MainTabView {
    func iconImage(_ imageString: String) -> some View {
        Image(systemName: imageString)
            .resizable()
            .frame(width: 30,height: 30)
    }
}
//#Preview {
//    MainTabView()
//}
