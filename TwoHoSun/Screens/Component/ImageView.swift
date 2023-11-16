//
//  ImageView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import SwiftUI

import Kingfisher

struct ImageView: View {
    var imageURL: String
    var ratio: Double = 1.5
    @State private var isImageLoadFailed = false

    var body: some View {
        if isImageLoadFailed {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.lightGray)
                    .aspectRatio(1.5, contentMode: .fit)
                Text("이미지 로딩에 실패했습니다")
                    .font(.system(size: 13))
                    .foregroundStyle(.white)
            }
        } else {
            KFImage(URL(string: imageURL))
                .placeholder {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.gray100))
                }
                .onFailure { _ in
                    isImageLoadFailed.toggle()
                }
                .cancelOnDisappear(true)
                .resizable()
                .aspectRatio(ratio, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(.rect(cornerRadius: 16))
        }
    }
}

#Preview {
    ImageView(imageURL: "https://test.hyunwoo.tech/images/profiles/null")
}
