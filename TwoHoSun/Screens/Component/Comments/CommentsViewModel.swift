//
//  CommentsViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/18/23.
//
import Combine
import SwiftUI

final class CommentsViewModel: ObservableObject {
    @Published var comments: String = ""
    @Published var commentsDatas = [CommentsModel]() {
        didSet {
            print(commentsDatas)
        }
    }
    @Published var presentAlert = false
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
        apiManager.request(.commentService(.getComments(postId: postId)), decodingType: [CommentsModel].self)
            .compactMap(\.data)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print(completion)
            } receiveValue: { data in
                self.commentsDatas = data
            }
            .store(in: &bag)
    }
    
    func postComment() {
        apiManager.request(.commentService(.postComment(postId: postId, contents: comments)), decodingType: NoData.self)
            .sink { completion in
                print(completion)
            } receiveValue: { response in
                print(response)
                self.comments = ""
                self.getAllComments()
            }
            .store(in: &bag)
    }

    func deleteComments(commentId: Int) {
        apiManager.request(.commentService(.deleteComments(commentId: commentId)), decodingType: NoData.self)
            .sink { completion in
                print(completion)
            } receiveValue: { res in
                self.comments = ""
                self.getAllComments()
                self.presentAlert.toggle()
            }
            .store(in: &bag)
    }

    func postReply(commentId: Int) {
        apiManager.request(.commentService(.postReply(commentId: commentId, contents: comments)), decodingType: NoData.self)
            .sink { completion in
                print(completion)
            } receiveValue: { res in
                self.comments = ""
                self.getAllComments()
                print("success")
            }
            .store(in: &bag)
    }
}
