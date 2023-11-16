//
//  TypeTestButton.swift
//  TwoHoSun
//
//  Created by 김민 on 11/11/23.
//

import SwiftUI

struct GoToTypeTestButton: View {
    
    @EnvironmentObject private var pathManager: NavigationManager
    var body: some View {
        Button {
            pathManager.navigate(.testIntroView)
        } label: {
            Text("소비 성향 테스트하러가기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .background(Color.lightBlue)
                .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    GoToTypeTestButton()
}
