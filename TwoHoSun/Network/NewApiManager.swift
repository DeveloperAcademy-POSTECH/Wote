//
//  NewApiManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/11/23.
//
import Combine
import SwiftUI

import Moya

@Observable
class NewApiManager {
//    private var cancellables: Set<AnyCancellable> = []
    var provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])
    var authenticator: Authenticator
    init( authenticator: Authenticator = Authenticator()) {
        self.authenticator = authenticator
    }

    func request<T: Decodable>(_ request: APIService, decodingType: T.Type) -> AnyPublisher<GeneralResponse<T>, NetworkError> {
        return provider.requestPublisher(request)
            .tryMap({ response in
                try self.handleResponse(response, decodingType)
            })
            .mapError { error in
                if let netWorkError = error as? ErrorResponse {
                    let errortype =  NetworkError(divisionCode: netWorkError.divisionCode)
                    switch errortype {
                    case .exipredJWT:
                        self.refetchToken()
                    default:
                        print(errortype)
                    }
                    return errortype
                } else {
                    return NetworkError(divisionCode: "unknown")
                }
            }
            .eraseToAnyPublisher()
    }

    private func handleResponse<T: Decodable>(_ response: Response, _ responseType: T.Type) throws -> GeneralResponse<T> {
        guard response.statusCode == 200 else {
            let decodedData = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
          throw decodedData
        }
        let decodedData = try JSONDecoder().decode(GeneralResponse<T>.self, from: response.data)
        return decodedData
    }

    private func refetchToken() {
        self.request(.refreshToken, decodingType: Tokens.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    self.authenticator.authState = .allexpired
                }
            } receiveValue: { response in
                guard let data = response.data else {return}
                KeychainManager.shared.saveToken(key: "accessToken", token: data.accessToken)
                KeychainManager.shared.saveToken(key: "refreshToken", token: data.refreshToken)
            }

    }
}
