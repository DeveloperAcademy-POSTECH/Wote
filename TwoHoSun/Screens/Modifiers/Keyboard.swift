//
//  Keyboard.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import SwiftUI

struct Keyboard: ViewModifier {
    @State var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .padding(.bottom,offset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                    let keyboardHeight = keyboardValue.height
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.offset = keyboardHeight
                    }
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.offset = 0
                    }
                }
            }
    }
}
