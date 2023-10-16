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
            appleLoginButton
        }
    }
}

extension LoginView {
    var appleLoginButton: some View {
        SignInWithAppleButton( onRequest: { request in
            request.requestedScopes = [.fullName, .email]
        }, onCompletion: {result in
            switch result {
            case .success(let authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    let identifier = appleIDCredential.user
                    KeychainManager.shared.saveToken(key: "identifier", token: identifier)
                    let authorization = String(data: appleIDCredential.authorizationCode!, encoding:  .utf8)
                    guard let authorizationCode = authorization else { return }
                    viewModel.postAuthorCode(authorizationCode)
                default:
                    break
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
        .frame(height: 54)
        .cornerRadius(27)
        .padding(.horizontal, 26)
    }
}

#Preview {
    LoginView()
}
