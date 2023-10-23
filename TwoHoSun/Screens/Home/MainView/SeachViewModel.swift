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
    var searchWords = [String]()
    var isFetching = false
    
    init() {
        guard let recentSearch = UserDefaults.standard.array(forKey: "RecentSearch") as? [String] else { return }
        searchWords = recentSearch
    }

    func fetchRecentSearch() {
        guard let recentSearch = UserDefaults.standard.array(forKey: "RecentSearch") as? [String] else { return }
        print(recentSearch)
        searchWords = recentSearch
    }

    func setRecentSearch(searchWord: String) {
        searchWords.insert(searchWord, at: 0)
        if searchWords.count > 5 {
            searchWords.removeLast()
        }
        UserDefaults.standard.set(searchWords, forKey: "RecentSearch")
    }

    func remove(at index: Int) {
        searchWords.remove(at: index)
        searchedDatas.removeAll()
    }

    func fetchSearchedData(page: Int = 0, size: Int = 20, keyword: String) {
        isFetching = true
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
                self.isFetching = false
            }
        }
    }
}
