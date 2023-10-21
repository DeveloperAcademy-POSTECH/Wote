//
//  WriteVIew.swift
//  TwoHoSun
//
//  Created by 235 on 10/19/23.
//

import SwiftUI

struct WriteView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white
        }
        .navigationTitle("소비고민 등록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
        }
    }
}

extension WriteView {

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        WriteView()
    }
}
