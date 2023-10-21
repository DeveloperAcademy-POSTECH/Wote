//
//  MainViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI
import Observation
import Combine

import Alamofire

@Observable
final class MainViewModel {
    var datalist:  [PostResponse] = []
    var isEmptyList: Bool {
        return datalist.isEmpty
    }
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        getPosts()
    }

    func getPosts() {
        let requestURL = URLConst.baseURL + "/api/posts"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
        ]
        let params: Parameters = [
            "page" : "0",
            "size" : "30"
        ]

        AF.request(requestURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: GeneralResponse<[PostResponse]>.self)
            .value()
            .map(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Errrorr 삐용삐용 후에 에러코드여러개면 후처리 예정.")
//                    switch error.responseCode {
//                        case
//                    }
                }
            } receiveValue: { [weak self] data in
                guard let self = self, let data = data else {return}
                print(data)
                self.datalist = data

            }
            .store(in: &subscriptions)
    }
}
