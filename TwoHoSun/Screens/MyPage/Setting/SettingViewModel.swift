//
//  SettingViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 11/22/23.
//

import SwiftUI

@Observable
class SettingViewModel {
    var apiManager: NewApiManager
    
    init(apiManager: NewApiManager) {
        self.apiManager = apiManager
    }
    
    func requestLogOut() {
        
    }
}
