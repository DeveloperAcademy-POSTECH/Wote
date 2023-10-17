//
//  URLConst.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import Foundation

struct URLConst {
    static var baseURL: String {
        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("BASE_URL is missing in the Info.plist")
        }
        return baseURL.replacingOccurrences(of: " ", with: "")
    }
}
