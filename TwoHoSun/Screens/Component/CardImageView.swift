//
//  CardImageView.swift
//  TwoHoSun
//
//  Created by 관식 on 11/17/23.
//

import SwiftUI

import Kingfisher

struct CardImageView: View {
    var imageURL: String?
    
    var body: some View {
        if let imageURL = imageURL {
            KFImage(URL(string: imageURL))
                .placeholder {
                    ProgressView()
                }
                .onFailure { error in
                    print(error.localizedDescription)
                }
                .cancelOnDisappear(true)
                .resizable()
                .clipShape(.rect(cornerRadius: 8))
                .frame(width: 66, height: 66)
        } else {
            Image("icnDummyLogo")
                .frame(width: 66, height: 66)
                .foregroundStyle(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    CardImageView()
}
