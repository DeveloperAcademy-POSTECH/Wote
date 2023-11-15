//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showDetailComments = false
    @State private var showconfirm = false
    @State private var backgroundColor: Color = .background
    @State private var showCustomAlert = false
    @State private var applyComplaint = false
    @State private var alertOn = false
    var viewModel: DetailViewModel
    var postId: Int
    var isMine = false

    enum VoteType {
        case agree, disagree
        var title: String {
            switch self {
            case .agree:
                return "추천"
            case .disagree:
                return "비추천"
            }
        }
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            if let postDetailData = viewModel.postDetailData {
                ScrollView {
                    VStack(spacing: 0) {
                        detailHeaderView(author: postDetailData.author,
                                         isMine: postDetailData.isMine)
                            .padding(.top, 18)
                        Divider()
                            .background(Color.disableGray)
                            .padding(.horizontal, 12)
                        detailCell(postDetailData: postDetailData)
                            .padding(.top, 27)
                        VoteView(postStatus: postDetailData.postStatus,
                                 myChoice: postDetailData.myChoice,
                                 voteCount: postDetailData.voteCount,
                                 voteCounts: postDetailData.voteCounts)
                            .padding(.horizontal, 24)
                        commentPreview
                            .padding(.horizontal, 24)
                            .padding(.vertical, 48)
                        voteResultView(type: .agree, 0.47)
                            .padding(.bottom, 36)
                        voteResultView(type: .disagree, 0.33)
                        Spacer()
                            .frame(height: 56)
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                    .scaleEffect(1.3, anchor: .center)
            }

            if showDetailComments {
                Color.black.opacity(0.7)
            }
            if showCustomAlert {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    CustomAlertModalView(alertType: .ban(nickname: "선호"), isPresented: $showCustomAlert) {
                        print("신고접수됐습니다.")
                    }
                }
            }

            if applyComplaint {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.lightBlue)
                            .frame(width: 283, height: 36)

                        Text("신고해주셔서 감사합니다.")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .onTapGesture {
                        applyComplaint.toggle()
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("상세보기")
                    .foregroundStyle(Color.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showconfirm.toggle()
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.subGray1)
                })
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showDetailComments) {
                CommentsView(showComplaint: $showCustomAlert, applyComplaint: $applyComplaint)
                    .presentationDetents([.large,.fraction(0.9)])
                    .presentationContentInteraction(.scrolls)
        }
        .onAppear {
            viewModel.fetchPostDetail(postId: postId)
        }
    }
}
extension DetailView {

    // TODO: - isMine 분리
    private func detailHeaderView(author: Author, isMine: Bool?) -> some View {
        HStack(spacing: 0) {
            ProfileImageView(imageURL: author.profileImage)
                .frame(width: 32, height: 32)
                .padding(.trailing, 10)
            Text(author.nickname)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
            Text("님의 구매후기 받기")
                .font(.system(size: 14))
                .foregroundStyle(Color.whiteGray)
            Spacer()
//            if isMine {
//                // TODO: 내껀지 남의껀지 보고 버튼놓기
//            } else {
//                Toggle("", isOn: $alertOn)
//                    .toggleStyle(AlertCustomToggle())
//            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 13)
    }

    private func detailCell(postDetailData: PostModel) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 13) {
                SpendTypeLabel(spendType: .beautyLover, usage: .standard)
                Text(postDetailData.title)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 18, weight: .bold))
                if let contents = postDetailData.contents {
                    Text(contents)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.whiteGray)
                }
                HStack(spacing: 0) {
                    if let price = postDetailData.price {
                        Text("가격: \(price)원")
                    }
                    Text(" · ")
                    Text(postDetailData.modifiedDate.convertToStringDate() ?? "")
                }
                .foregroundStyle(Color.priceGray)
                .font(.system(size: 14))
                .padding(.top, 3)
            }
            .padding(.bottom, 16)

            HStack {
                Label("\(postDetailData.voteCount)명 투표", systemImage: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white)
                    .frame(width: 94, height: 29)
                    .background(Color.darkGray2)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
                Spacer()
                Button {
                    print("이야 공유하자")
                } label: {
                    Label("공유", systemImage: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white)
                        .frame(width: 63, height: 29)
                        .background(Color.lightBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 34))
                }
            }
            .padding(.bottom, 4)

            if let externalURL = postDetailData.externalURL {
                Link(destination: URL(string: externalURL)!, label: {
                    Text(externalURL)
                        .tint(Color.white)
                        .font(.system(size: 16))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .truncationMode(.tail)
                        .lineLimit(1)
                        .padding(.vertical,10)
                        .padding(.horizontal,14)
                        .background(Color.lightGray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                })
            }

            Group {
                if let imageURL = postDetailData.image {
                    ImageView(imageURL: imageURL)
                } else {
                    Image("imgDummyVote\((postDetailData.id) % 3 + 1)")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1.5, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 16))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }

//    @ViewBuilder
//    func detailTextView(title: String, price: Int, contents: String) -> some View {
//        VStack(alignment: .leading, spacing: 13) {
//            SpendTypeLabel(spendType: .beautyLover, usage: .standard)
//            Text(title)
//                .foregroundStyle(Color.white)
//                .font(.system(size: 18, weight: .bold))
//            Text(contents)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .lineLimit(3)
//                .multilineTextAlignment(.leading)
//                .foregroundStyle(Color.whiteGray)
//
//            HStack(spacing: 9) {
//                Text("2023년 8월 2일 · 가격: \(price)원")    .foregroundStyle(Color.priceGray)
//                    .font(.system(size: 14))
//            }
//            .padding(.top, 3)
//        }
//        .padding(.bottom, 36)
//    }

    var commentPreview: some View {
        CommentPreview()
            .onTapGesture {
                showDetailComments.toggle()
            }
    }

    func voteResultView(type: VoteType, _ percent: Double) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("구매 \(type.title) 의견")
                .font(.system(size: 14))
                .foregroundStyle(Color.priceGray)
            HStack(spacing: 8) {
                // TODO: - 여기 계산해야 함.
                SpendTypeLabel(spendType: .budgetKeeper, usage: .standard)
                SpendTypeLabel(spendType: .ecoWarrior, usage: .standard)
            }
            Text("투표 후 구매 \(type.title) 의견을 선택한 유형을 확인해봐요!")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
            ProgressView(value: percent)
                .frame(height: 8)
                .tint(Color.lightBlue)
                .background(Color.darkGray2)
                .padding(.top, 8)
        }
        .padding(.horizontal, 24)
    }
}
struct AlertCustomToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        return ZStack {
            RoundedRectangle(cornerRadius: 17)
                .strokeBorder(Color.white, lineWidth: 2)
                .frame(width: 65, height: 25)
                .background(isOn ? Color.lightBlue : Color.darkblue)
                .overlay(alignment: .leading) {
                    Text(isOn ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white)
                        .offset(x: isOn ? 6 : 28)
                        .padding(.trailing, 8)
                }
                .overlay(alignment: .leading) {
                    Image("smile")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .frame(width: 15,height: 15)
                        .clipShape(Circle())
                        .rotationEffect(Angle.degrees(isOn ? 180 : 0))
                        .offset(x: isOn ? 45 : 6)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 17)
                        .frame(width: 65, height: 25)
                }
        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }
        }
    }
}
