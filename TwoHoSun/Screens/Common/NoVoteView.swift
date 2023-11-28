//
//  NoVoteView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/11/23.
//

import SwiftUI

struct NoVoteView: View {
    @Binding var selectedVisibilityScope: VisibilityScopeType
    @AppStorage("haveConsumerType") var haveConsumerType: Bool = false
    @Environment(AppLoginState.self) private var loginState

    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                Image("imgNoVote")
                Text("아직 소비고민이 없어요.\n투표 만들기를 통해 소비고민을 등록해보세요.")
                    .foregroundStyle(Color.subGray1)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                Button {
                    guard haveConsumerType else {
                        loginState.serviceRoot.navigationManager.navigate(.testIntroView)
                        return
                    }

                    loginState.serviceRoot.navigationManager.navigate(.makeVoteView)
                } label: {
                    Text("고민 등록하러 가기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.lightBlue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.lightBlue, lineWidth: 1)
                        }
                }
            }
            Spacer()
        }
    }
}
