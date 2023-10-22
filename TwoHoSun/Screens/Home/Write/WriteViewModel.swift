//
//  WriteViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/22/23.
//

import Foundation

import Alamofire

@Observable
final class WriteViewModel {
    var title = ""
    var externalURL = ""
    var content = ""
    var tagText = ""
    var tags = [String]()
    var postCreateModel: PostCreateModel?

    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }

    func removeTag(_ word: String) {
        if !tags.isEmpty {
            let index = tags.firstIndex(of: word)!
            tags.remove(at: index)
        }
    }
    
    func createPost() {
        postCreateModel = PostCreateModel(postType: PostType.allSchool.rawValue,
                                          title: title,
                                          contents: content,
                                          image: "",
                                          externalURL: externalURL,
                                          postTagList: tags)
        guard let postCreateModel = postCreateModel else { return }

        APIManager.shared.requestAPI(type: .postCreate(postCreate: postCreateModel)) { (response: GeneralResponse<NoData>) in
            switch response.status {
            case 401:
                APIManager.shared.refreshAllTokens()
                self.createPost()
            case 200:
                print("Post Success!")
            default:
                print(response.message)
            }
        }
    }
}