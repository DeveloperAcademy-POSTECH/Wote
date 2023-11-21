//
//  TypeTestIntroView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import SwiftUI

struct TypeTestIntroView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppLoginState.self) private var loginStateManager

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Image("imgTypeTest")
                    .padding(.bottom, 7)
                Text("나의 소비 성향은 뭘까?")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.white)
                VStack(spacing: 0) {
                    Text("테스트를 진행하지 않으면 Wote에서")
                    Text("투표와 관련된 서비스를 이용할 수 없어요")
                }
                .font(.system(size: 16))
                .foregroundStyle(Color.subGray1)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
                goToTestButton
                Spacer()
                dismissButton
                    .padding(.bottom, 35)
            }
            .padding(.horizontal, 24)
        }
    }
}

extension TypeTestIntroView {

    private var goToTestButton: some View {
        Button {
            loginStateManager.serviceRoot.navigationManager.navigate(.testView)
        } label: {
            Text("소비 성향 테스트하러가기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color.lightBlue)
                .clipShape(.rect(cornerRadius: 10))
        }
    }

    private var dismissButton: some View {
        Button {
           dismiss()
        } label: {
            HStack(spacing: 7) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                Text("닫기")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(Color.subGray1)
        }
    }
}

#Preview {
    NavigationStack {
        TypeTestIntroView()
    }
}
