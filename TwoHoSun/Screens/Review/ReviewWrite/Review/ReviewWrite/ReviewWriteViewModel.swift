//
//  ReviewWriteViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/7/23.
//

import Combine
import Foundation

@Observable
final class ReviewWriteViewModel {
    var isPurchased: Bool = true
    var title: String = ""
    var price: String = ""
    var content = ""
    var post: SummaryPostModel
    var review: ReviewCreateModel?
    var image: Data?
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()
    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }
    
    init(post: SummaryPostModel, apiManager: NewApiManager) {
        self.post = post
        self.apiManager = apiManager
    }
    
    func setReview() {
        review = ReviewCreateModel(title: title,
                                   contents: content.isEmpty ? nil : content,
                                   price: price.isEmpty ? nil : Int(price),
                                   isPurchased: isPurchased,
                                   image: image)
    }
    
    func createReview() {
        setReview()
        guard let review = review else { return }
        apiManager.request(.postService(.createReview(postId: post.id, review: review)), decodingType: NoData.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { _ in
                print("create review finished!")
            }
            .store(in: &cancellable)
    }
}
