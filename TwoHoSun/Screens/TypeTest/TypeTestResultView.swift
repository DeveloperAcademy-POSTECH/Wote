//
//  TypeTestResultView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import SwiftUI

struct TypeTestResultView: View {
    var spendType: ConsumerType
    @Environment(\.dismiss) private var dismiss
    @Environment(AppLoginState.self) private var loginStateManager

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 50)
                HStack {
                    Text(spendType.description)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.lightBlue)
                        .kerning(-1)
                    Spacer()
                }
                .padding(.bottom, 24)
                HStack {
                    Text(spendType.title)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                Spacer()
                ZStack {
                    ParticleView()
                    spendType.icon
                }
                Spacer()
                pushToHomeButton
                dismissButton
                    .onTapGesture {
                        dismiss()
                    }
                    .padding(.vertical, 35)
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            loginStateManager.serviceRoot.memberManager.fetchProfile()
        }
    }
}

extension TypeTestResultView {

    private var pushToHomeButton: some View {
        Button {
            loginStateManager.serviceRoot.navigationManager.navigate(.makeVoteView)
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                loginStateManager.serviceRoot.navigationManager.countDeque(count: 2)
            }
        } label: {
            Text("소비 고민 등록하러 가기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.lightBlue)
                .clipShape(.rect(cornerRadius: 10))
        }
    }

    private var dismissButton: some View {
        Button(action: {
            loginStateManager.serviceRoot.navigationManager.countPop(count: 2)
        }, label: {
            HStack(spacing: 7) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                Text("닫기")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundStyle(Color.subGray1)
        })
    }
}

#Preview {
    TypeTestResultView(spendType: .riskAverse)
}
