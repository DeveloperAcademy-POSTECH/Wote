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
//            .flatMap { response in
//                if response.statusCode == 200 {
//                    return Just(response.data)
//                        .setFailureType(to: NetworkError.self)
//                        .eraseToAnyPublisher()
//                } else {
//                    let networkError = NetworkError(divisionCode: response.m)
//                }
//
//                   }
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    do {
                        let json = try err.response?.mapJSON()
                        debugPrint(json)
//                        let errordata = JSONDecoder.decode(ErrorResponse.self, from: err.response?.data)
                    } catch {
                        debugPrint(error)
                    }
                    print(err)
                }
            } receiveValue: { response in
                do {
                    let data = try JSONDecoder().decode(GeneralResponse<Tokens>.self, from: response.data)
                    if data.status == 401 {
                        APIManager.shared.refreshAllTokens()
                        self.postAuthorCode()
                    } else {
                        if let data = data.data {
                            KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
                            KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
                        }
                        if data.message == "UNREGISTERED_USER" {
                            self.showSheet = true
                        } else {
                            self.goMain = true
                        }
                    }
                } catch {
                    debugPrint(error)
                }
            }
    }
}

