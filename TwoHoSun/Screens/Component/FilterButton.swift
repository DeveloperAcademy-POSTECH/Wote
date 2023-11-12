//
//  FilterButton.swift
//  TwoHoSun
//
//  Created by 김민 on 11/6/23.
//

import SwiftUI

struct FilterButton: View {
    let title: String
    var isSelected: Bool
    var selectedBackgroundColor = Color.lightBlue
    var selectedForegroundColor = Color.white
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? selectedForegroundColor : Color.gray100)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? selectedBackgroundColor : Color.disableGray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    FilterButton(title: "필터",
                 isSelected: true) {
        print("filter button did tap")
    }
}
