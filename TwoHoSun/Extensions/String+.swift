//
//  String+.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation
extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.date(from: self)
    }
}
