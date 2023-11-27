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
    var content: String = ""
    var image: Data?
    var post: SummaryPostModel
    var review: ReviewCreateModel?
    var isCompleted = false
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()
    var isValid: Bool {
        if isPurchased {
            if !title.isEmpty && image != nil {
                return true
            } else {
                return false
            }
        } else {
            if !title.isEmpty {
                return true
            } else {
                return false
            }
        }
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
        apiManager.request(.postService(.createReview(postId: post.id, review: review)), 
                           decodingType: NoData.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { _ in
                self.isCompleted = true
            }
            .store(in: &cancellable)
    }
    
    func clearData(_ state: Bool) {
        isPurchased = state
        title = ""
        price = ""
        content = ""
        image = nil
    }
}
