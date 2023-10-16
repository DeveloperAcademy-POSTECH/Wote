//
//  BottomSheetView.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI

struct BottomSheetView: View {
    var body: some View {
        ZStack {
            Button(action: {}, label: {
                Image(systemName: "xmark")
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topLeading)
            })
            Text("약관 동의")
                .font(Font.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    BottomSheetView()
}
