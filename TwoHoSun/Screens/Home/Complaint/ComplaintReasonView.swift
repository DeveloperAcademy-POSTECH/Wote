//
//  ComplaintReasonView.swift
//  TwoHoSun
//
//  Created by 235 on 11/7/23.
//

import SwiftUI

struct ComplaintReasonView: View {
    @Binding var isSheet: Bool
    @Binding var isComplaintApply: Bool
    var complaint : ComplaintReason
    @State var isuserBlock = false

    var body: some View {
        ZStack {
            Color
                .background
                .ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("신고 사유:")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.bottom, 26)
                    Text(complaint.title)
                        .foregroundStyle(Color.lightBlue)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.bottom, 24)
                    HStack {
                        Image(systemName: isuserBlock ? "checkmark.square" : "square")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.gray9595)
                        Text("이 사용자 차단하기")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    .onTapGesture {
                        isuserBlock.toggle()
                    }
                    .padding(.bottom, 10)
                    Text("'(마이페이지 > 앱 설정 > 사용자 차단 목록'에서 취소할 수 있습니다.)")
                        .foregroundStyle(Color.darkGray)
                        .font(.system(size: 14))
                        .padding(.bottom, 23)
                }
                .padding(.horizontal, 24)
                transferComplaintButton
                    .padding(.horizontal, 16)
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("신고사유")
                    .foregroundStyle(Color.white)
            }
        }
    }
}

extension ComplaintReasonView {
    var transferComplaintButton: some View {
        Button {
            isComplaintApply.toggle()
            isSheet.toggle()
        } label: {
            Text("Wote에게 전달하기")
                .foregroundStyle(.white)
                .font(.system(size: 16))
                .frame(maxWidth: .infinity)
        }
        .frame(height: 52)
        .background(Color.disableGray)
        .clipShape(.rect(cornerRadius: 10))
    }
}
