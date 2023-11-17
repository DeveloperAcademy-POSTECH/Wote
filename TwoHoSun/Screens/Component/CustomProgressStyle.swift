//
//  CustomProgressStyle.swift
//  TwoHoSun
//
//  Created by 김민 on 11/17/23.
//

import SwiftUI

struct CustomProgressStyle: ProgressViewStyle {
    var foregroundColor: Color
    var height: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0

        GeometryReader { geometry in
            Rectangle()
                .fill(Color.black100)
                .frame(width: geometry.size.width, height: height)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(foregroundColor)
                        .frame(width: geometry.size.width * progress)
                }
                .clipShape(.rect(cornerRadius: 24))
        }
    }
}
