//
//  Keyboard.swift
//  TwoHoSun
//
//  Created by 235 on 11/5/23.
//

import SwiftUI
struct Keyboard: ViewModifier {
    @State var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .padding(.bottom,offset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    let value = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    self.offset = height
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    self.offset = 0
                }
            }
    }
}
