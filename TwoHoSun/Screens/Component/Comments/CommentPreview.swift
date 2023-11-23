//
//  CommentPreview.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

struct CommentPreview: View {
    @Environment(AppLoginState.self) private var loginStateManager

    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Text("댓글")
                    .foregroundStyle(Color.priceGray)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
            }
            HStack(spacing: 7) {
                if let image = loginStateManager.appData.profile?.profileImage {
                    ProfileImageView(imageURL: image)
                        .frame(width: 24, height: 24)
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
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
    }
}

#Preview {
    CommentPreview()
}
