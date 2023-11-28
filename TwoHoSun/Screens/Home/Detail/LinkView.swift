//
//  LinkView.swift
//  TwoHoSun
//
//  Created by 김민 on 10/20/23.
//

import SwiftUI
import WebKit

struct LinkView: View {
    @Environment(\.dismiss) var dismiss
    var externalURL: String

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                dismissButton
                Spacer()
            }
            LinkWebView(externalURL: externalURL)
        }
    }
}

extension LinkView {

    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundStyle(.white)
        }
        .padding(.leading, 16)
    }
}

struct LinkWebView: UIViewRepresentable {
    var externalURL: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: externalURL) else {
            return WKWebView()
        }

        let webView = WKWebView()
        webView.load(URLRequest(url: url))

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
}

#Preview {
    LinkView(externalURL: "https://www.youtube.com/watch?v=kvRBrtrqjHc")
}
