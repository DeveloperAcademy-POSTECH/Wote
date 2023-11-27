//
//  PostManager.swift
//  TwoHoSun
//
//  Created by 김민 on 11/23/23.
//

import SwiftUI

@Observable
final class PostManager {
    var posts = [PostModel]()
    var myPosts = [SummaryPostModel]()
    var removeCount = 0

    func deleteReviews(postId: Int) {
        posts.removeAll { $0.id == postId }
        myPosts.removeAll { $0.id == postId }
    }

    func updateVote(postID: Int) {
        if let index = myPosts.firstIndex(where: { $0.id == postID }) {
            myPosts[index].hasReview = true
        } 
    }
}
