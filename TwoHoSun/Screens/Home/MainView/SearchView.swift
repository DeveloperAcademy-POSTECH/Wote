//
//  SearchView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/21/23.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @State private var searchText = ""
    @State private var dismissTabBar: Bool = false
    @State private var hasResult: Bool = false
    private let viewModel = SearchViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundStyle(hasResult ? .clear : .black)

            if hasResult {
                if viewModel.isFetching {
                    ProgressView()
                        .padding(.top, 100)
                } else if viewModel.searchedDatas.isEmpty {
                    Spacer()
                    emptyResultView
                } else {
                    ScrollView {
                        ForEach(viewModel.searchedDatas) { data in
                            MainCellView(postData: data)
                        }
                    }
                }
            } else {
                recentSearchView
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                searchField
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(dismissTabBar || hasResult ? .visible : .hidden, for: .tabBar)
    }
}

extension SearchView {
    private var backButton: some View {
        Button {
            dismissTabBar.toggle()
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundStyle(.gray)
        }
    }
    
    private var searchField: some View {
        ZStack(alignment: .trailing) {
            TextField("원하는 소비항목을 검색해보세요.", text: $searchText)
                .font(.system(size: 14))
                .frame(height: 30)
                .padding(.leading, 12)
                .background(
                    hasResult ? Color(UIColor.secondarySystemBackground) : .white
                )
                .clipShape(.capsule)
                .onSubmit {
                    hasResult = true
                    viewModel.setRecentSearch(searchWord: searchText)
                    viewModel.fetchSearchedData(keyword: searchText)
                }
            if hasResult {
                Button {
                    hasResult = false
                    searchText.removeAll()
                    viewModel.fetchRecentSearch()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .padding(.trailing, 4)
                }
            }
        }
    }
    
    private var recentSearchView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("최근 검색어")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                Spacer()
            }
            WrappingHStack(horizontalSpacing: 8) {
                ForEach(Array(zip(viewModel.searchWords.indices, viewModel.searchWords)), id: \.0) { index, word in
                    Button {
//                        viewModel.searchWords.remove(at: index)
//                        viewModel.searchedDatas.removeAll()
                        viewModel.remove(at: index)
                    } label: {
                        HStack(spacing: 5) {
                            Text(word)
                                .font(.system(size: 14))
                            Image(systemName: "xmark")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.gray)
                        .fixedSize()
                        .frame(height: 28)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule()
                                .stroke(Color.gray, lineWidth: 1)
                                .foregroundStyle(.white)
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 16)
    }

    private var emptyResultView: some View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(width: 90, height: 90)
            Text("검색 결과가 없습니다.")
                .font(.system(size: 20, weight: .medium))
        }
        .foregroundStyle(.gray)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}

private struct WrappingHStack: Layout {
    private var horizontalSpacing: CGFloat
    private var verticalSpacing: CGFloat
    
    public init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat? = nil) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing ?? horizontalSpacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }

        let height = subviews.map { $0.sizeThatFits(proposal).height }.max() ?? 0

        var rowWidths = [CGFloat]()
        var currentRowWidth: CGFloat = 0
        subviews.forEach { subview in
            if currentRowWidth + horizontalSpacing + subview.sizeThatFits(proposal).width >= proposal.width ?? 0 {
                rowWidths.append(currentRowWidth)
                currentRowWidth = subview.sizeThatFits(proposal).width
            } else {
                currentRowWidth += horizontalSpacing + subview.sizeThatFits(proposal).width
            }
        }
        rowWidths.append(currentRowWidth)

        let rowCount = CGFloat(rowWidths.count)
        return CGSize(width: max(rowWidths.max() ?? 0, proposal.width ?? 0), height: rowCount * height + (rowCount - 1) * verticalSpacing)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let height = subviews.map { $0.dimensions(in: proposal).height }.max() ?? 0
        guard !subviews.isEmpty else { return }
        var tmpX = bounds.minX
        var tmpY = height / 2 + bounds.minY
        subviews.forEach { subview in
            tmpX += subview.dimensions(in: proposal).width / 2
            if tmpX + subview.dimensions(in: proposal).width / 2 > bounds.maxX {
                tmpX = bounds.minX + subview.dimensions(in: proposal).width / 2
                tmpY += height + verticalSpacing
            }
            subview.place(
                at: CGPoint(x: tmpX, y: tmpY),
                anchor: .center,
                proposal: ProposedViewSize(
                    width: subview.dimensions(in: proposal).width,
                    height: subview.dimensions(in: proposal).height
                )
            )
            tmpX += subview.dimensions(in: proposal).width / 2 + horizontalSpacing
        }
    }
}
