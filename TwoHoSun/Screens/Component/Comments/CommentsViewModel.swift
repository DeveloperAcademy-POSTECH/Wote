//
//  CommentsViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/18/23.
//

import SwiftUI

final class CommentsViewModel: ObservableObject {
    @Published var commentsDatas = [CommentsModel]()
    @Published var content: String = ""
    private var apiManager: NewApiManager
    private var postId: Int

    init(apiManager: NewApiManager, postId: Int) {
        self.apiManager = apiManager
        self.postId = postId
    }

    func getAllComments() {
        apiManager.request(.commentService(.getComments(postId: postId)), decodingType: CommentsModel.self )
            .sink { completion in
                print(completion)
            } receiveValue: { response in
                print(response)
            }
    }

//    func postComment() {
//        apiManager.request(.commentService(.postComments(postComment: <#T##CommentPostModel#>)), decodingType: <#T##Decodable.Protocol#>)
//    }

}
