//
//  SeachViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/23/23.
//

import Foundation

@Observable
final class SearchViewModel {
    var searchedDatas = [PostModel]()

    func fetchSearchedData(page: Int = 1, size: Int = 10, keyword: String) {
        APIManager.shared.requestAPI(
            type: .getSearchResult(page: page, size: size, keyword: keyword)
        ) { (response: GeneralResponse<[PostResponse]>) in
            if response.status == 401 {
                APIManager.shared.refreshAllTokens()
                self.fetchSearchedData(keyword: keyword)
            } else {
                guard let data = response.data else { return }
                let result = data.map { PostModel(from: $0) }
                self.searchedDatas = result
            }
        }
    }
}
