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

    var body: some View {
        KFImage(URL(string: imageURL))
            .placeholder {
                ProgressView()
            }
            .onFailure { error in
                print(error.localizedDescription)
            }
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(ratio, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    ImageView(imageURL: "https://test.hyunwoo.tech/images/profiles/null")
}
