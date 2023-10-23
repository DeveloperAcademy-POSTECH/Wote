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
    var externalURL = " "
    var content = " "
    var postCategoryType = PostCategoryType.purchaseConsideration
    var postCreateModel: PostCreateModel?

    var isTitleValid: Bool {
        guard !title.isEmpty else { return false }
        return true
    }
    
    func createPost() {
        postCreateModel = PostCreateModel(postType: PostType.allSchool.rawValue,
                                          title: title + " " + postCategoryType.title,
                                          contents: content,
                                          image: "",
                                          externalURL: externalURL,
                                          postTagList: [],
                                          postCategoryType: postCategoryType.rawValue)
        guard let postCreateModel = postCreateModel else { return }

        print(postCreateModel)

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
