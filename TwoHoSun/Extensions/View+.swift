//
//  Views.swift
//  TwoHoSun
//
//  Created by 235 on 10/20/23.
//

import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
