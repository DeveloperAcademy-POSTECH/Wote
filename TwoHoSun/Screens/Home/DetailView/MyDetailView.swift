////
////  MyDetailView.swift
////  TwoHoSun
////
////  Created by 관식 on 10/22/23.
////
//
//import SwiftUI
//
//struct MyDetailView: View {
//    
//    @State private var writerName: String = "깜찍이머리핀용주"
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                detailHeaderView
//                ChartView(voteInfoList: <#[VoteInfo]#>)
//            }
//        }
//    }
//}
//
//extension MyDetailView {
//    private var detailHeaderView: some View {
//        HStack {
//            Image(systemName: "person.fill")
//                .frame(width: 30, height: 30)
//                .clipShape(Circle())
//            Text(writerName)
//                .font(.system(size: 16, weight: .medium))
//            Spacer()
//        }
//        .padding(.horizontal, 26)
//    }
//}
//
//#Preview {
//    MyDetailView()
//}
