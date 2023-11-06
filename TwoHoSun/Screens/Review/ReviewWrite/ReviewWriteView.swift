//
//  ReviewWriteView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import SwiftUI

struct ReviewWriteView: View {
    @State private var isBuy: Bool = true
    @Bindable private var viewModel: ReviewWriteViewModel = ReviewWriteViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(spacing: 48) {
                        VStack(spacing: 12) {
                            VoteCardView(cardType: .simple, searchFilterType: .end, isPurchased: true)
                            buySelection
                        }
                        
                    }
                }
                .padding(.top, 16)
                reviewRegisterButton
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("후기 작성하기")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .medium))
                }
            }
        }
    }
}

extension ReviewWriteView {
    
    private var buySelection: some View {
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.darkblue, lineWidth: 1)
                HStack {
                    if !isBuy {
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.lightBlue)
                        .frame(width: geo.size.width / 2)
                    if isBuy {
                        Spacer()
                    }
                }
                HStack(spacing: 0) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isBuy = true
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.clear)
                                .frame(width: geo.size.width / 2)
                            Text("샀다")
                                .font(.system(size: 16, weight: isBuy ? .bold : .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: geo.size.width / 2, height: 44)
                    .contentShape(Rectangle())
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isBuy = false
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.clear)
                                .frame(width: geo.size.width / 2)
                            Text("안샀다")
                                .font(.system(size: 16, weight: isBuy ? .bold : .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: geo.size.width / 2)
                }
            }
        }
        .frame(height: 44)
    }
    
    private var reviewRegisterButton: some View {
        Button {
            //            isRegisterButtonDidTap = true
            //            if viewModel.isTitleValid {
            //                viewModel.createPost()
            //                isWriteViewPresented = false
            //            }
        } label: {
            Text("등록하기")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.title != "" ? Color.lightBlue : Color.disableGray)
                .cornerRadius(10)
        }
    }
    
    private func headerLabel(_ title: String, essential: Bool) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white)
        + Text(essential ? "(필수)" : "(선택)")
            .font(.system(size: 12, weight: essential ? .semibold : .medium))
            .foregroundStyle(essential ? .red : Color.subGray3)
    }
}

#Preview {
    NavigationStack {
        ReviewWriteView()
    }
}
