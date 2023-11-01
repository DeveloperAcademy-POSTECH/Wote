//
//  MainViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI
import Observation
import Combine

import Alamofire

@Observable
final class MainViewModel {
    var datalist: [PostModel] = []
    var nextIndex = 0
    var lastPage = false
    var loading = true
    var isEmptyList: Bool = false

    func getPosts(_ size: Int = 10, first: Bool = false) {
        APIManager.shared.requestAPI(type: .getPosts(page: nextIndex, size: size)) { (response: GeneralResponse<[PostResponse]>) in
            switch response.status {
            case 200:
                guard let data = response.data else {return}
                let postModels = data.map { PostModel(from: $0)}
                self.datalist = first ? postModels : self.datalist + postModels
                self.lastPage = data.count < 10 ? true : false
                self.nextIndex += 1
                self.loading = false
            case 401:
                APIManager.shared.refreshAllTokens()
                self.getPosts(size)
            default:
                print("error서버문제 바구니에게 문의하세요")
            }
        }
    }
}
