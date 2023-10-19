//
//  DetailView.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI
// TODO: 후에 모델작업은 수정 예정 여기서 사용하기 위해 임의로 제작
struct Comment {
    let nickname: String
    let writetime: Int
    let profileImage: String
    let commentData: String
}
struct DetailView : View {
    var userData : [Comment] = [Comment(nickname: "우왁굳", writetime: 1, profileImage: "profile", commentData: "이야 이걸 안사? ")]
    @State private var commentText: String = ""
    @State private var writerName: String = "김아무개"
    @State private var alertOn: Bool = false
    var body: some View {
        headerView
    }

}

extension DetailView {
    private var headerView: some View {
        HStack {
            Image(systemName: "person")
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            Text(writerName)
                .font(.system(size: 16))
            Text("님의 구매후기 받기")
                .font(.system(size: 14))
            Spacer()
            Toggle("", isOn: $alertOn)
                .toggleStyle(AlertCustomToggle())

        }
        .padding(.horizontal, 26)
    }
}
struct AlertCustomToggle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        var isOn = configuration.isOn
        return ZStack {
            RoundedRectangle(cornerRadius: 17)
                .frame(width: 61, height: 21)
                .foregroundStyle(Color.gray)
                .overlay(alignment: .leading) {
                    Text(isOn ? "ON" : "OFF")
                        .font(.system(size: 14, weight: .bold))
                        .offset(x: isOn ? 5 : 25)
                        .padding(.trailing, 8)
                }
                .overlay(alignment: .leading) {
                    Image("smile")
                        .resizable()
                        .frame(width: 15,height: 15)
                        .clipShape(Circle())
                        .rotationEffect(Angle.degrees(isOn ? 180 : 0))
                        .offset(x: isOn ? 35 : 5)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 17)
                        .frame(width: 61, height: 21)
                }

        }
        .onTapGesture {
            withAnimation {
                configuration.isOn.toggle()
            }

        }
    }
}

extension DetailView {
//    var commentView : some View {
//        ScrollView {
//            LazyVStack(alignment: .leading, spacing: 24) {
//                ForEach(userData) { comment in
//                    CommentCell(comment: comment)
//                }
//            }
//        }
//        .padding(.top)
//
////        CustomInputView(inputText: $commentText, action: uploadComment)
//
//    }

//    var customInputView: some View {
//        TextField("소비고민을 함께 나누어 보세요.", text: $commentText)
//            .textFieldStyle(CommentTextFieldStyle)
//
//    }

}
//struct CommentTextFieldStyle: TextFieldStyle {
//    typealias _Body = <#type#>
//    
//
////    func _body(configuration: TextField<Self._Label>) -> some View {
////        configuration
////    }
//
//
//}
#Preview {
    DetailView()
}
