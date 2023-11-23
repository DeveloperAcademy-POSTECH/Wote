//
//  TestViewModel.swift
//  TwoHoSun
//
//  Created by 김민 on 11/22/23.
//

import SwiftUI

struct TestView: View {
    @StateObject var viewModel: TestViewModel

    var body: some View {
        Text("hi")
    }
}

class TestViewModel: ObservableObject {
    private var apiManager: NewApiManager

    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
}
