//
//  SeachViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/23/23.
//
import Combine
import Foundation

@Observable
final class SearchViewModel {
    var searchHistory = [String]()
    var isFetching = false
    var searchedDatas: [SummaryPostModel] = []
    private var apiManager: NewApiManager
    var selectedFilterType = PostStatus.active
    var selectedVisibilityScope: VisibilityScopeType
    private var bag = Set<AnyCancellable>()
    init(apiManager: NewApiManager, selectedVisibilityScope: VisibilityScopeType) {
        self.apiManager = apiManager
        self.selectedVisibilityScope = selectedVisibilityScope
        fetchRecentSearch()
    }

    func fetchRecentSearch() {
        guard let recentSearch = UserDefaults.standard.array(forKey: "RecentSearch") as? [String] else { return }
        searchHistory = recentSearch
    }

    func addRecentSearch(searchWord: String) {
        searchHistory.insert(searchWord, at: 0)
        if searchHistory.count > 12 {
            searchHistory.removeLast()
        }
        setRecentSearch()
    }

    func removeRecentSearch(at index: Int) {
        searchHistory.remove(at: index)
        setRecentSearch()
    }

    func removeAllRecentSearch() {
        searchHistory.removeAll()
        setRecentSearch()
    }

    func setRecentSearch() {
        UserDefaults.standard.set(searchHistory, forKey: "RecentSearch")
    }
    // TODO: - fetching result data
    func fetchSearchedData(page: Int = 0, size: Int = 20, keyword: String) {
        isFetching = true
        apiManager.request(.postService(
            .getSearchResult(postStatus: selectedFilterType,
                             visibilityScopeType: selectedVisibilityScope,
                             page: page, size: size, keyword: keyword)),
                           decodingType: [SummaryPostModel].self)
        .compactMap(\.data)
        .sink { completion in
            print(completion)
        } receiveValue: { data in
            print(data)
            self.searchedDatas.append(contentsOf: data)
            self.isFetching = false
            self.addRecentSearch(searchWord: keyword)
        }
        .store(in: &bag)
    }
}
