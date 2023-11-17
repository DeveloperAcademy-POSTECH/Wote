//
//  CommentsViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/18/23.
//
import Combine
import SwiftUI


final class CommentsViewModel: ObservableObject {
    @Published var commentsDatas = [CommentsModel]()
//    @Published var content: String = ""
    private var apiManager: NewApiManager
    private var postId: Int
    var bag = Set<AnyCancellable>()

    init(apiManager: NewApiManager, postId: Int) {
        self.apiManager = apiManager
        self.postId = postId
        self.getAllComments()
    }

    func getAllComments() {
        apiManager.request(.commentService(.getComments(postId: postId)), decodingType: CommentsModel.self )
            .sink { completion in
                print(completion)
            } receiveValue: { response in
                print(response)
            }
            .store(in: &bag)
    }

    func postComment(content: String) {
        apiManager.request(.commentService(.postComment(postId: postId, contents: content)), decodingType: NoData.self)
            .sink { completion in
                print(completion)
            } receiveValue: { response in
                print(response)
            }
            .store(in: &bag)

    }

}
