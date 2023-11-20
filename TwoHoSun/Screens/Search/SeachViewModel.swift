//
//  SeachViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/23/23.
//
import Combine
import Foundation

final class SearchViewModel: ObservableObject {
    @Published var searchHistory = [String]()
    var isFetching = false
    @Published var searchedDatas: [SummaryPostModel] = []
    private var apiManager: NewApiManager
    @Published var selectedFilterType = PostStatus.active
    @Published var page = 0
    @Published var showEmptyView = false
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

    func fetchSearchedData(keyword: String, reset: Bool = false, save: Bool = false) {
        isFetching.toggle()
        if reset {
            page = 0
            self.searchedDatas = []
        }
        var cancellable: AnyCancellable?
        cancellable =  apiManager.request(.postService(
            .getSearchResult(postStatus: selectedFilterType,
                             visibilityScopeType: selectedVisibilityScope,
                             page: page, size: 8, keyword: keyword)),
                           decodingType: [SummaryPostModel].self)
        .compactMap(\.data)
        .sink { completion in
            print(completion)
        } receiveValue: { data in
            self.searchedDatas.append(contentsOf: data)
            self.isFetching.toggle()
            if save {
                self.addRecentSearch(searchWord: keyword)
            }
            self.showEmptyView = self.searchedDatas.isEmpty
            self.page += 1
            cancellable?.cancel()
        }
    }
}
