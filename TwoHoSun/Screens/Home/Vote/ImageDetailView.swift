//
//  ImageDetailView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI

import Kingfisher

struct ImageDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isLinkWebViewPresented = false
    var imageURL: String
    var externalURL: String

    var body: some View {
        ZStack {
            Color.black
            ZStack(alignment: .bottomTrailing) {
                imageView
                detailLinkButton
                    .padding(.trailing, 26)
                    .padding(.bottom, 18)
            }
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                dismissButton
            }

            ToolbarItem(placement: .principal) {
                Text("1 / 1")
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
            }
        }
        .fullScreenCover(isPresented: $isLinkWebViewPresented) {
            NavigationView {
                LinkView(externalURL: externalURL)
            }
        }
    }
}

extension ImageDetailView {

    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
        }
    }

    private var imageView: some View {
        KFImage(URL(string: imageURL)!)
            .placeholder {
                ProgressView()
            }
            .onFailure { error in
                print(error.localizedDescription)
            }
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
    }

    private var detailLinkButton: some View {
        Button {
            isLinkWebViewPresented = true
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "link")
                Text("링크")
            }
            .font(.system(size: 16))
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 19))
        }
    }
}

#Preview {
    NavigationView {
        ImageDetailView(imageURL: "https://picsum.photos/200/300",
                        externalURL: "https://youtu.be/SfqR33YnEAE?si=5QLZhFhwGKZb2hZB")
    }
}
