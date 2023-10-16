//
//  Onboarding.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI

struct OnBoardingView : View {
    @State private var currentpage = 0

    var body: some View {
        VStack {
            horizontalScroll
                .padding(EdgeInsets(top: 14, leading: 0, bottom: 47, trailing: 40))
            TabView(selection: $currentpage,
                    content: {
                onboardingPage(title: "첫번째 온보딩\n여기에 들어가", description: "대충첫번재 온보딩이란뜻", onboardingImage: UIImage(systemName: "photo")!)
                    .tag(0)
                onboardingPage(title: "두번째 온보딩\n여기에 들어가", description: "대충두번재 온보딩이란뜻어쩌고저쩌고", onboardingImage: UIImage(systemName: "photo")!)
                    .tag(1)
                LoginView().tag(2)
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }

    var horizontalScroll: some View {
        HStack {
            Spacer()
            ForEach(0..<3) { idx in
                if idx == currentpage {
                    Rectangle()
                        .frame(width: 28,height: 9)
                        .clipShape(RoundedRectangle(cornerRadius: 21))
                } else {
                    Circle().frame(width: 8, height: 8)
                        .foregroundStyle(Color.gray)
                }
            }
        }
    }

    @ViewBuilder
    func onboardingPage(title: String, description: String, onboardingImage: UIImage) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 19) {
                Text(title)
                    .font(.system(size: 36, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.leading, 40)
            //MARK: 여기에 이미지 들어가야하기에 크기는 임의로 잡아서 잡아둠.
            Image(uiImage: onboardingImage)
                .resizable()
                .frame(width: 52,height: 52)
                .padding(EdgeInsets(top: 129, leading: 160, bottom: 270, trailing: 160))
            Button(action: {}, label: {
                Text("다음")
                    .frame(width: 361,height: 52)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            .buttonStyle(PlainButtonStyle())

        }
    }
}

#Preview {
    OnBoardingView()
}
