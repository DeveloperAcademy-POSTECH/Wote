//
//  WriteViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/22/23.
//

import Alamofire
import Combine
import Foundation

@Observable
final class VoteWriteViewModel {
    var title: String = ""
    var price: String = ""
    var externalURL: String = ""
    var content: String = ""
    var image: Data?
    var visibilityScope: VisibilityScopeType
    var postCreateModel: PostCreateModel?
    private var apiManager: NewApiManager
    private var cancellable = Set<AnyCancellable>()
    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }
    
    init(visibilityScope: VisibilityScopeType, apiManager: NewApiManager) {
        self.visibilityScope = visibilityScope
        self.apiManager = apiManager
    }
    
    func setPost() {
        postCreateModel = PostCreateModel(visibilityScope: visibilityScope,
                                          title: title,
                                          price: price.isEmpty ? nil : Int(price),
                                          contents: content.isEmpty ? nil : content,
                                          externalURL: externalURL.isEmpty ? nil : externalURL,
                                          image: image)
    }
    
    func createPost() {
        setPost()
        guard let postCreateModel = postCreateModel else { return }
        apiManager.request(.postService(.createPost(post: postCreateModel)), decodingType: NoData.self)
            .compactMap(\.data)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error: \(error)")
                }
            } receiveValue: { _ in
                print("create post finished!")
            }
            .store(in: &cancellable)
    }
}
