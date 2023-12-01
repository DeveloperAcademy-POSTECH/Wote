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

    func customConfirmDialog<A: View>(isPresented: Binding<Bool>, isMine: Binding<Bool>?,
                                      @ViewBuilder actions: @escaping  (Binding<Bool>) -> A) -> some View {
        return self.modifier(CustomConfirmModifier(isPresented: isPresented, actions: actions,
                                                   isMine: isMine ?? Binding.constant(true)))
    }

    func errorAlert(error: Binding<NetworkError?>, 
                    buttonTitle: String = "OK",
                    action: @escaping () -> Void) -> some View {
        return alert("",
                     isPresented: Binding<Bool>(
                        get: { error.wrappedValue != nil },
                        set: { if !$0 { error.wrappedValue = nil }}
                     )) {
                         Button(buttonTitle) {
                             error.wrappedValue = nil
                             action()
                         }
                    } message: {
                        Text(error.wrappedValue?.errorDescription ?? "")
                    }

    }
}
