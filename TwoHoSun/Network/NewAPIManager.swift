//
//  NewAPIManager.swift
//  TwoHoSun
//
//  Created by 235 on 11/10/23.
//

import SwiftUI
import Combine
import Moya

//class NewAPIManager {
//    let provider: MoyaProvider<APIService>
//    init(provider: MoyaProvider<APIService> = .init()) {
//        self.provider = provider
//    }
//    func getRefreshToken(refreshToken: String, identifier: String)
//}
//protocol ProviderProtocol {
//    associatedtype Target: APIService
//    func request<T: Decodable>(_ targetType: Target) -> AnyPublisher<T, Error>
//}
//
//class APIClient<Target: TargetType
//class NewAPIManager {
//    static let shared = NewAPIManager()
//    private let provider = MoyaProvider<APIService>()
//    func request<T: Decodable>(_ target: APIService, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
//        provider.request(target) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    let data = try response.map(T.self)
//                    completion(.success(data))
//                } catch let error {
//                    completion(.failure(error))
//                }
//            case .failure(let err):
//                print(err)
//            }
//        }
//        
//    }
//}
public extension MoyaProvider {
    static var networkLoggerPlugin: NetworkLoggerPlugin {
         return NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
     }

     // Define a class-level MoyaProvider with the NetworkLoggerPlugin
     static func makeProvider<T>() -> MoyaProvider<T> {
         return MoyaProvider<T>(plugins: [networkLoggerPlugin])
     }
    func requestPublisher(_ target: Target, callbackQueue: DispatchQueue? = nil) -> AnyPublisher<Response, MoyaError> {
           return MoyaPublisher { [weak self] subscriber in
                   return self?.request(target, callbackQueue: callbackQueue, progress: nil) { result in
                       switch result {
                       case let .success(response):
                           _ = subscriber.receive(response)
                           subscriber.receive(completion: .finished)
                       case let .failure(error):
                           subscriber.receive(completion: .failure(error))
                       }
                   }
               }
               .eraseToAnyPublisher()
       }
}
