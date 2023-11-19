//
//  EndLabel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/18/23.
//

import SwiftUI

struct EndLabel: View {
    var body: some View {
        Text("종료")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.disableGray)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}

#Preview {
    EndLabel()
}
