//
//  LoginView.swift
//  TwoHoSun
//
//  Created by 235 on 10/15/23.
//
import AuthenticationServices
import SwiftUI

struct LoginView: View {
    let viewModel = LoginViewModel()
    var body: some View {
        VStack {
            appleLoginBtn
        }
    }
    var appleLoginBtn: some View {
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
    }
}
