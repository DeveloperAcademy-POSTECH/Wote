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
    var cornerRadius: CGFloat = 16
    @State private var isImageLoadFailed = false

    var body: some View {
        if isImageLoadFailed {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.lightGray)
                    .aspectRatio(ratio, contentMode: .fit)
                Image(systemName: "exclamationmark.square")
                    .font(.system(size: 15))
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
                .clipShape(.rect(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    ImageView(imageURL: "https://test.hyunwoo.tech/images/profiles/null")
}
