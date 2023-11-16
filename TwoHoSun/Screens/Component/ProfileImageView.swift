//
//  ProfileImageView.swift
//  TwoHoSun
//
//  Created by 김민 on 11/14/23.
//

import SwiftUI

import Kingfisher

struct ProfileImageView: View {
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
                .clipShape(Circle())
        } else {
            Image("defaultProfile")
                .resizable()
        }
    }
}
