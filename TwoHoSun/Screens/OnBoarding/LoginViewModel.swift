//
//  LoginViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/16/23.
//
import SwiftUI

import Alamofire
import Combine
import Moya

class LoginViewModel: ObservableObject {
    @Published var showSheet = false
    @Published var authorization: String = ""
    @Published var goMain = false

    func setAuthorizationCode(_ code: String) {
        self.authorization = code
    }
    private var cancellable: AnyCancellable?
//    let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))

    let provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])

    func postAuthorCode() {
        cancellable = provider.requestPublisher(.postAuthorCode(authorization: authorization))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    print(err)
                }
            } receiveValue: { response in
                print(response)
            }
    }
}

