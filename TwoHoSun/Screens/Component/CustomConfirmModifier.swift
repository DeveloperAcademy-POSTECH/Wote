//
//  CustomConfirmModifier.swift
//  TwoHoSun
//
//  Created by 235 on 11/1/23.
//

import SwiftUI

struct CustomConfirmModifier<A>: ViewModifier where A: View {
    @Binding var isPresented: Bool
    let actions: (Binding<Bool>) -> A
    @Binding var isMine: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ZStack(alignment: .bottom) {
                if isPresented {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isPresented = false
                        }
                        .transition(.opacity)
                    VStack(alignment: .center) {
                        GroupBox {
                            actions($isMine)
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        .groupBoxStyle(TransparentGroupBox())
                        GroupBox {
                            Button("취소", role: .cancel) {
                                isPresented = false
                            }
                            .bold()
                            .font(.system(size: 20))
                            .foregroundStyle(Color.white)
                            .padding(.vertical, 17)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .groupBoxStyle(TransparentGroupBox())
                    }
                    .font(.system(size: 18, weight: .medium))
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .bottom))
                }
            }
            .onTapGesture {
                isPresented = false
            }
            .animation(.easeInOut, value: isPresented)
        }
    }
}
struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.disableGray))
    }
}
