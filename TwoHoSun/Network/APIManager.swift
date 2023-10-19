//
//  APIManager.swift
//  TwoHoSun
//
//  Created by 관식 on 10/19/23.
//

import Combine
import Foundation

import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    private var cancellable: Set<AnyCancellable> = []
    
    func refreshAllTokens() {
        let requestURL = URLConst.baseURL + "/api/auth/refresh"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let body: [String: String] = [
            "refreshToken": KeychainManager.shared.readToken(key: "refreshToken")!,
            "identifier": KeychainManager.shared.readToken(key: "identifier")!
        ]
        
        AF.request(requestURL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .publishDecodable(type: GeneralResponse<Tokens>.self)
            .value()
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { data in
                guard let tokens = data else { return }
                KeychainManager.shared.updateToken(key: "accessToken", token: tokens.accessToken)
                KeychainManager.shared.updateToken(key: "refreshToken", token: tokens.refreshToken)
            }
            .store(in: &cancellable)
    }
}
