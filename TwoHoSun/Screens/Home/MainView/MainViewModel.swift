//
//  MainViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 10/18/23.
//

import SwiftUI
import Observation

@Observable
class MainViewModel {
    var datalist:  [String] = []
    var isEmptyList: Bool {
        return datalist.isEmpty
    }
}
