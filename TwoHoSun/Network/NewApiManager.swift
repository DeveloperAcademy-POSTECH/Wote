//
//  NewApiManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/11/23.
//
import Combine
import SwiftUI

import Moya

class NewApiManager {
    static let shared = NewApiManager()
    private var cancellables: Set<AnyCancellable> = []
    let provider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])
    func request<T: Decodable>(_ service: APIService, 
                               responseType: T.Type,
                               successHandler: @escaping (GeneralResponse<T>) -> Void,
                               errorHandler: @escaping (NetworkError) -> Void) {
       NewApiManager.shared.provider.requestPublisher(service)
            .tryMap({ response in
                try self.handleResponse(response, responseType)
            })
            .mapError({ error in
                if let netWorkError = error as? ErrorResponse {
                    switch NetworkError(divisionCode: netWorkError.divisionCode) {
                    case .exipredJWT:
                        self.request(.refreshToken, responseType: Tokens.self) { response in
                            guard let data = response.data else {return}
                            KeychainManager.shared.updateToken(key: "accessToken", token: data.accessToken)
                            KeychainManager.shared.updateToken(key: "refreshToken", token: data.refreshToken)
                        } errorHandler: { err in
                            // TODO: refreshToken도 만료되었을때 다시 로그인창으로 가게 하게
                            print(err)
                        }
                        return NetworkError(divisionCode: netWorkError.divisionCode)
                    default:
                        return NetworkError(divisionCode: netWorkError.divisionCode)
                    }
                } else {
                    return NetworkError(divisionCode: "unknown")
                }
            })
            .sink {
                print($0)
            } receiveValue: { response in
                print(response)
                print(response.status)
                successHandler(response)
            }
            .store(in: &cancellables)
    }

    private func handleResponse<T: Decodable>(_ response: Response, _ responseType: T.Type) throws -> GeneralResponse<T> {
        guard response.statusCode == 200 else {
            let decodedData = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
          throw decodedData
        }
        let decodedData = try JSONDecoder().decode(GeneralResponse<T>.self, from: response.data)
        return decodedData
    }
}
