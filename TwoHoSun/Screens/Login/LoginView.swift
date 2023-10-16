//
//  LoginView.swift
//  TwoHoSun
//
//  Created by 235 on 10/15/23.
//
import SwiftUI

import AuthenticationServices

struct LoginView: View {
    let viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            //MARK: 현재는 임의의 로고 추후에 로고 이미지박스로 변경 예정
            Image(systemName: "keyboard")
                .resizable()
                .frame(width: 234, height: 72)
            Text("중고등 학생들의 소비고민을 어쩌고 할거야")
                .font(Font.system(size: 16))
                .padding(.top,18)
            Image(systemName: "photo")
                .resizable()
                .frame(width: 52, height: 52)
                .padding(.top,128)
                .padding(.bottom,235)
            Text("계속하려면 로그인 하세요")
                .font(Font.system(size: 16))
            appleLoginButton
        }.padding(.top, 100)
    }
    var appleLoginButton: some View {
        SignInWithAppleButton( onRequest: { request in
            request.requestedScopes = [.fullName, .email]
        }, onCompletion: {result in
            switch result {
            case .success(let authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding:  .utf8)
                    guard let authcode = authorizationCode else { return }
                    print(authcode)
                    viewModel.postAuthorCode(authorizationCode: authcode)
                default:
                    break
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
        .frame(width: 336,height: 54)
        .cornerRadius(46)
    }
}

#Preview {
    LoginView()
}
