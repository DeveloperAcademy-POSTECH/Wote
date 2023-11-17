//
//  Double+.swift
//  TwoHoSun
//
//  Created by 김민 on 11/16/23.
//

import Foundation

extension Double {

    var getFirstDecimalNum: Int {
        return Int((self * 10).truncatingRemainder(dividingBy: 10))
    }
}
