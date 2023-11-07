//
//  TypeTestResultView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/8/23.
//

import SwiftUI

struct TypeTestResultView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Text("가성비보다 가심비 중심의 소비를 하는")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.lightBlue)
                        .padding(.bottom, 24)
                    Spacer()
                }
                HStack {
                    Text("플렉스킹")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                Spacer()
                Rectangle()
                    .frame(width: 225, height: 209)
                    .foregroundStyle(.pink)
                Spacer()
                retryButton
                    .padding(.bottom, 12)
                pushToHomeButton
                dismissButton
                    .padding(.vertical, 35)
            }
            .padding(.horizontal, 24)
        }
    }
}

extension TypeTestResultView {

    private var retryButton: some View {
        Button {
            print("retry button")
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .medium))
                Text("다시하기")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.disableGray)
            .clipShape(.rect(cornerRadius: 10))
        }
    }

    private var pushToHomeButton: some View {
        Button {
            print("screen transition to home")
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
        Button {
            print("close")
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
    TypeTestResultView()
}
