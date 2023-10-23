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
    @State private var currentpage = 0
    @State private var goProfileView = false
    @ObservedObject var viewModel = LoginViewModel()
    @Binding var navigationPath: [Route]
    
    var body: some View {
            VStack {
                ZStack {
                    if currentpage != 0 {
                        backButton
                            .padding(EdgeInsets(top: 8, leading: 24, bottom: 47, trailing: 350))
                    }
                    horizontalScroll
                        .padding(EdgeInsets(top: 14, leading: 0, bottom: 47, trailing: 40))
                }
                TabView(selection: $currentpage,
                        content: {
                    onboardingPage(title: "첫번째 온보딩\n여기에 들어가", 
                                   description: "중고등학생들의 소비 고민을 어쩌고 할 거야",
                                   onboardingImage: UIImage(systemName: "photo")!)
                                .tag(0)
                    onboardingPage(title: "두번째 온보딩\n여기에 들어가", 
                                   description: "중고등학생들의 소비 고민을 어쩌고 할 거야",
                                   onboardingImage: UIImage(systemName: "photo")!)
                                .tag(1)
                    loginBoardingPage
                                .tag(2)
                })
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .onChange(of: viewModel.goMain, { _, newValue in
                if newValue {
                    self.navigationPath.append(.mainTabView)
                }
            })
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .mainTabView:
                    MainTabView()
                case .profileView:
                    ProfileSettingsView(navigationPath: $navigationPath, viewModel: ProfileSettingViewModel())
                }
            }

    }
}

extension OnBoardingView {
    private var backButton: some View {
        Button {
            currentpage -= 1
        } label: {
            Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 8, height: 16)
                .padding(.leading, 16)
                .foregroundStyle(Color.gray)
        }
    }

    private var horizontalScroll: some View {
        HStack {
            Spacer()
            ForEach(0..<3) { idx in
                if idx == currentpage {
                    Rectangle()
                        .frame(width: 28,height: 9)
                        .clipShape(RoundedRectangle(cornerRadius: 21))
                } else {
                    Circle().frame(width: 8, height: 8)
                        .foregroundStyle(Color.gray)
                }
            }
        }
    }

    private func onboardingPage(title: String, description: String, onboardingImage: UIImage) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 19) {
                Text(title)
                    .font(.system(size: 36, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.leading, 40)
            // MARK: 여기에 이미지 들어가야하기에 크기는 임의로 잡아서 잡아둠.
            Image("dummyImg")
                .resizable()
                .frame(width: 52,height: 52)
                .padding(EdgeInsets(top: 129, leading: 160, bottom: 270, trailing: 160))
            Button {
                if currentpage < 2 {
                    currentpage += 1
                }
            } label: {
                Text("다음")
                    .frame(width: 361,height: 52)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var loginBoardingPage: some View {
        VStack {
            // TODO: 현재는 임의의 로고 추후에 로고 이미지박스로 변경 예정
            Image("vote")
                .resizable()
                .frame(width: 234, height: 72)
                .padding(.top, 65)
            Text("중고등 학생들의 소비고민을 어쩌고 할거야")
                .font(Font.system(size: 18))
                .padding(.top, 18)
            Image("dummyImg")
                .resizable()
                .frame(width: 52, height: 52)
                .padding(.top, 128)
                .padding(.bottom, 190)
            Text("계속하려면 로그인 하세요")
                .font(Font.system(size: 16))
                .padding(.bottom, 8)
            appleLoginButton
            hyeprLinkText
                .font(.system(size: 10))
                .padding(.vertical,8)
        }.sheet(isPresented: $viewModel.showSheet) {
            BottomSheetView(navigationPath: $navigationPath)
                .presentationDetents([.medium])
        }
    }

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
        .frame(height: 54)
        .cornerRadius(27)
        .padding(.horizontal, 26)
    }

    private var hyeprLinkText: some View {
        HStack {
            Text("[이용 약관](https://codeisfuture.tistory.com/59)")+Text(" 및 ") + Text("[개인정보 보호정책](https://codeisfuture.tistory.com/)") + Text(" 확인하기")
        }
    }
}
//#Preview {
//    OnBoardingView()
//}
