//
//  Onboarding.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//

import SwiftUI

import AuthenticationServices
import Combine

struct OnBoardingView : View {
    @State private var goProfileView = false
    @State var viewModel: LoginViewModel
    @Environment(AppLoginState.self) private var loginState
    @State private var navigationPath: [LoginNavigation] = []
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Image("onboardingBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 26) {
                            Image("logo")
                            Text("청소년의 소비고민, 투표로 물어보기")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        Spacer()
                    }
                    .padding(.top, 120)
                    Spacer()
                    Image("onboardingIllust")
                    Spacer()
                    VStack(spacing: 12) {
                        Text("계속하려면 로그인 하세요")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.bottom, 4)
                        appleLoginButton
                        hyeprLinkText
                    }
                    .padding(.bottom, 60)
                }
                .padding(.horizontal, 26)
            }
            .sheet(isPresented: $viewModel.showSheet) {
                BottomSheetView(navigationPath: $navigationPath)
                    .presentationDetents([.medium])
            }
            .onChange(of: viewModel.goMain, { _, newValue in
                if newValue {
                    self.navigationPath.append(.mainTabView)
                }
            })
            .navigationDestination(for: LoginNavigation.self) { route in
                switch route {
                case .mainTabView:
                    WoteTabView(path: $navigationPath)
                case .profileView:
                    ProfileSettingsView(viewType: .setting, 
                                        viewModel: ProfileSettingViewModel(appState: loginState))
                }
            }
        }
    }
}

extension OnBoardingView {
    private var appleLoginButton: some View {
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
                    viewModel.setAuthorizationCode(authorizationCode)
                    viewModel.postAuthorCode()
                default:
                    break
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        })
        .signInWithAppleButtonStyle(.white)
        .frame(height: 54)
        .cornerRadius(27)
    }

    private var hyeprLinkText: some View {
        HStack {
            Text("[이용 약관](https://codeisfuture.tistory.com/59)")+Text(" 및 ") + Text("[개인정보 보호정책](https://codeisfuture.tistory.com/)") + Text(" 확인하기")
        }
        .font(.system(size: 12))
        .foregroundStyle(Color.subGray1)
    }
}
