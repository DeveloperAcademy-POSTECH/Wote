//
//  ComplaintView.swift
//  TwoHoSun
//
//  Created by 235 on 11/6/23.
//

import SwiftUI
enum ComplaintReason: CaseIterable {
    case spam, sexual, abuse, copyright, suicide, advertise, abnormal
    var title: String {
        switch self {
        case .spam:
            return "스팸"
        case .sexual:
            return "음란 · 성적 행위"
        case .abuse:
            return "욕설 · 폭력 · 혐오"
        case .copyright:
            return "명예훼손 · 저작권 등 권리침해"
        case .suicide:
            return "자살 · 자해"
        case .advertise:
            return "광고 · 사행성"
        case .abnormal:
            return "비정상적인 서비스 이용"
        }
    }
}
struct ComplaintView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isSheet: Bool
    @Binding var isComplaintApply: Bool

    var body: some View {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text("신고 사유를 선택해주세요.")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 24,weight: .semibold))
                        .padding(.leading, 12)

                    List {
                        ForEach(ComplaintReason.allCases, id: \.hashValue) { value in
                            NavigationLink(destination: 
                                            ComplaintReasonView(isSheet: $isSheet, isComplaintApply: $isComplaintApply, complaint: value)) {
                                Text(value.title)
                                    .foregroundStyle(Color.subGray3)
                            }
                            .overlay {
                                HStack {
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.subGray3)
                                }
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { dimension in
                                dimension[.leading] - 12
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 16, leading: 12, bottom: 16, trailing: 12))
                        .listRowSeparatorTint(Color.dividerGray)
                        .listRowBackground(Color.background)
                        .listSectionSeparator(.hidden, edges: .top)
                        .listSectionSeparator(.hidden, edges: .bottom)
                    }
                    .listStyle(.plain)
                }
                .padding(.horizontal,12)
            }

        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("신고하기")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 18, weight: .medium))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.lightBlue)
                }
            }
        }
    }
}
