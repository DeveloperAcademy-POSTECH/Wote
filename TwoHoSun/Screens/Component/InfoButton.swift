//
//  InfoButton.swift
//  TwoHoSun
//
//  Created by 김민 on 11/18/23.
//

import SwiftUI

struct InfoButton: View {
    var label: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
            Text(label)
        }
        .font(.system(size: 14))
        .foregroundStyle(.white)
        .padding(.vertical, 7)
        .padding(.horizontal, 10)
        .background(Color.darkGray2)
        .clipShape(.rect(cornerRadius: 34))
    }
}
