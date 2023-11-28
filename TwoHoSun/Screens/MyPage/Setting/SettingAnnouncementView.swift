//
//  SettingAnnouncementView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/13/23.
//

import SwiftUI

struct SettingAnnouncementView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ExpandableList()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.background)
        .toolbarBackground(.visible)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("공지사항")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
            }
        }
    }
}

struct ExpandableList: View {
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            expandableListCell
            if isExpanded {
                expandedContent
            }
        }
    }
}

extension ExpandableList {
    private var expandableListCell: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("23/12/05")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.subGray5)
                Text("안녕하세요. Wote. 첫 인사드립니다!")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
            Spacer()
            Image(systemName: "chevron.down")
                .font(.system(size: 16))
                .foregroundStyle(Color.subGray6)
                .rotationEffect(isExpanded ? Angle(degrees: 180) : .zero)
        }
        .padding(26)
        .background(Color.background)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.4)) {
                isExpanded.toggle()
            }
        }
        .zIndex(1)
    }
    
    private var expandedContent: some View {
        ZStack {
            Color.disableGray
            VStack(alignment: .leading, spacing: 20) {
                Text("# Wote. 출범 인사!")
                    .foregroundStyle(.white)
                    .font(.system(size: 14, weight: .bold))
                Image("announcement")
                    .resizable()
                    .scaledToFit()
                Text("""
                    안녕하세요.\n청소년들의 소비 문화에 관심을 가지고 기획하게 된 소비고민 투표 서비스 Wote 입니다. 
                    만나서 반갑습니다.:)\n\n청소년 여러분들의 소비 고민을 자유롭게 투표로 알아보고,
                    투표를 해준 친구들에게 실 사용 후기를 공유해 서로의 소비 가치관을 Wote와 함께 알아가보죠!
                    """)
                    .foregroundStyle(Color.subGray5)
                    .font(.system(size: 12))
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
    }
}

#Preview {
    NavigationStack {
        SettingAnnouncementView()
    }
}
