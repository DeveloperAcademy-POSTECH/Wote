//
//  MainVoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/1/23.
//

import SwiftUI

struct MainVoteView: View {
    var body: some View {
        ZStack {
            Color.background
        }
    }
}

extension MainVoteView {

    private var voteCategory: some View {
        Text("고등학교 투표")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white)
    }
}

#Preview {
    WoteTabView()
}
