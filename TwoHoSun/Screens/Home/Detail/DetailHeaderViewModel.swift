//
//  DetailHeaderViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/24/23.
//

import Combine
import SwiftUI

@Observable
final class DetailHeaderViewModel {
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }

    func subscribeReview(postId: Int) {
        apiManager.request(.postService(.subscribeReview(postId: postId)),
                           decodingType: NoData.self)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        } receiveValue: { _ in
            print("후기 구독 완료")
        }
        .store(in: &cancellable)
    }

    func deleteSubscribeReview(postId: Int) {
        apiManager.request(.postService(.deleteSubscribeReview(postId: postId)),
                           decodingType: NoData.self)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        } receiveValue: { _ in
            print("후기 구독 취소")
        }
        .store(in: &cancellable)
    }
}
