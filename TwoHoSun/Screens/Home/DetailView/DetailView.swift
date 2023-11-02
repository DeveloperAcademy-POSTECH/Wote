//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI
// TODO: 후에 모델작업은 수정 예정 여기서 사용하기 위해 임의로 제작
struct DetailView : View {
    @Environment(\.dismiss) var dismiss
    @State private var alertOn = false
    @State private var showDetailComments = false
    @State private var descriptionHeight = 0.0

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
            Color.background
                .ignoresSafeArea()
            ScrollView {
                detailHeaderView
                    .padding(.top, 35)
                Divider()
                    .padding(.horizontal, 12)
                detailCell
                    .padding(.top, 30)
                    .padding(.bottom, 24)
                commentPreview
                    .padding(.horizontal, 24)
                voteResultView(.agree, 0.47)
                    .padding(EdgeInsets(top: 32, leading: 0, bottom: 48, trailing: 0))
                voteResultView(.disagree, 0.33)
            }
         
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("소비고민", systemImage: "chevron.backward")
                        .foregroundStyle(Color.accentBlue)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("상세보기")
                    .foregroundStyle(Color.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}, label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.subGray1)
                })
            }
        }
        .sheet(isPresented: $showDetailComments, content: {

        })
    }
}
extension DetailView {
    private var detailHeaderView: some View {
        HStack(spacing: 0) {
            // TODO: 추후에 서버의 이미지와 연동
            Image("defaultProfile")
                .resizable()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .padding(.trailing, 10)
            Text( "일단써놈 ")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.whiteGray)
            Text("님의 구매후기 받기")
                .font(.system(size: 14))
                .foregroundStyle(Color.whiteGray)
            Spacer()
            Toggle("", isOn: $alertOn)
                .toggleStyle(AlertCustomToggle())
        }
        .padding(.horizontal, 24)

    }

    private var detailCell: some View {
        //TODO: 데이터 연결할것
        VStack(alignment: .leading) {
           detailTextView(title: "ACG마운틴 플라이 할인 살말?", price: 1000, description: "어쩌고저쩌고사고말고어쩌라고어쩌고저쩌고사고말고어쩌라고어쩌고저쩌고사고말고어쩌라고")

            VStack(spacing: 8) {
                Text("O사다")
                Text("X안사다")
            }
            .padding(.bottom, 24)
            .padding(.horizontal, 24)

            Image("logo")
                .resizable()
                .frame(height: 218)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            Link(destination: URL(string: "https://naver.com")!, label: {
                Text("https://naver.comeeeefqefewqfewqfewqfewqffqewfq")
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
            }).padding(.horizontal,24)

            HStack {
                Label("0명 투표", systemImage: "person.2.fill")
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
            .padding(.horizontal, 24)
            .padding(.top, 18)
        }
    }
    
    @ViewBuilder
    func detailTextView(title: String, price: Int, description: String) -> some View {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.bottom, 4)
                Text("금액: \(price)원")
                    .foregroundStyle(Color.priceGray)
                    .font(.system(size: 14))
                    .padding(.bottom, 18)
            }
            .padding(.leading, 20)
        GeometryReader { proxy in
            Text(description)
                .frame(width: proxy.size.width * 0.87)
                .fixedSize(horizontal: true, vertical: true)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.whiteGray)
                .background(GeometryReader { geo in
                    Text("")
                        .onAppear {
                            self.descriptionHeight = geo.size.height
                        }
                })
                .padding(.horizontal, 24)
        }
        .frame(height: descriptionHeight)
    }

    var commentPreview: some View {
        //TODO: 뷰모델에서 댓글이 있는지를 체크한담에 있으면 삼항연산자를 통해 할 예정
        VStack {
            HStack(spacing: 4) {
                Text("댓글")
                    .foregroundStyle(Color.priceGray)
                    .font(.system(size: 14, weight: .medium))
                //                if data가 있으면 {
                //                    Text("개")
                //                }
                Spacer()
            }
            HStack(spacing: 7) {
                Image("defaultProfile")
                    .resizable()
                    .frame(width: 24, height: 24)
                HStack {
                    Text("댓글 추가...")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.priceGray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.textFieldGray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Color.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            showDetailComments.toggle()
        }
    }

    func voteResultView(_ type: VoteType, _ percent: Double) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("구매 \(type.title) 의견")
                .font(.system(size: 14))
                .foregroundStyle(Color.priceGray)
            HStack(spacing: 8) {
                //TODO: viewModel로 부터 데이터를 받아서 어떤 유형인지 여기에 알려주면 댐.
                SpendTypeLabel(spendType: .saving)
                SpendTypeLabel(spendType: .ecoWarrior)

            }
            Text("투표 후 구매 \(type.title) 의견을 선택한 유형을 확인해봐요!")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white)
            ProgressView(value: percent)
                .frame(height: 8)
                .tint(Color.lightBlue)
                .background(Color.darkGray2)
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

#Preview {
    NavigationStack {
        DetailView()
    }
}
