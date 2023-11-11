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
    func request<T: Decodable>(_ service: APIService, responseType: T.Type, successHandler: @escaping (GeneralResponse<T>) -> Void, errorHandler: @escaping (NetworkError) -> Void) {
       NewApiManager.shared.provider.requestPublisher(service)
            .tryMap({ response in
                guard let decodedData = try? JSONDecoder().decode(GeneralResponse<T>.self, from: response.data) else {
                    throw try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                }
                return decodedData
            })
            .mapError({ error in
                print(error)
//                NetworkError(divisionCode: )
                return error
            })
            .sink {
                print($0)
            } receiveValue: { response in
                print(response)
                print(response.status)
                successHandler(response)
//                successHandler(response.da)
//                res
//                successHandler(response.data)
            }
            .store(in: &cancellables)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let err):
//                    errorHandler(err)
//                }
//            } receiveValue: { response in
//                do {
//                    let data = try JSONDecoder().decode(GeneralResponse<T>.self, from: response.data)
//                    if data.status == 401 {
//                        self.request(.refreshToken, responseType: Tokens.self) { data in
//                            KeychainManager.shared.updateToken(key: "accessToken", token: data.accessToken)
//                            KeychainManager.shared.updateToken(key: "refreshToken", token: data.refreshToken)
//                        } errorHandler: { err in
//                            print(err)
//                        }
//                        self.request(service, responseType: responseType, successHandler: successHandler, errorHandler: errorHandler)
//                    } else if data.status == 200 {
//                        guard let responseData = data.data else {return }
//                        successHandler(responseData)
//                    }
//                    else {
/////*                        */errorHandler(NetworkError(divisionCode: data.d)
//                    }
//                } catch {
//                    let data = JSONDecoder().decode(ErrorResponse.self, from: response.data)
//                    errorHandler(NetworkError(divisionCode: data.divisionCode))
//
////                    errorHandler(error)
//                }
//            }
    }

}
