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
        searchWords = recentSearch
    }

    func addRecentSearch(searchWord: String) {
        // TODO: set recent search storage limit
        searchWords.insert(searchWord, at: 0)
    }

    func removeRecentSearch(at index: Int) {
        searchWords.remove(at: index)
        searchedDatas.removeAll()
    }

    func removeAllRecentSearch() {
        searchWords.removeAll()
    }

    func setRecentSearch() {
        UserDefaults.standard.set(searchWords, forKey: "RecentSearch")
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
