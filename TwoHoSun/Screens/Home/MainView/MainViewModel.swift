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
    var datalist:  [PostResponse] = []
    var isEmptyList: Bool {
        return datalist.isEmpty
    }

    init() {
        getPosts(0, 30, first: true)
    }

    func getPosts(_ page: Int, _ size: Int, first: Bool = false) {
        APIManager.shared.requestAPI(type: .getPosts(page, size)) {  (response: GeneralResponse<[PostResponse]>) in
            switch response.status {
            case 200:
                guard let data = response.data else {return}
                print(data)
                self.datalist = first ? data : self.datalist + data
            case 401:
                APIManager.shared.refreshAllTokens()
                self.getPosts(page, size)
            default:
                print("error서버문제 바구니에게 문의하세요")
            }
        }

    }
}
