//
//  PurchaseLabel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/7/23.
//

import SwiftUI

struct PurchaseLabel: View {
    var isPurchased: Bool
    
    var body: some View {
        Text(isPurchased ? "샀다" : "안샀다")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .background(Color.lightBlue)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}

#Preview {
    PurchaseLabel(isPurchased: true)
}
