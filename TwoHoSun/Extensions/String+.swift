//
//  String+.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

extension String {

    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.date(from: self)
    }

    func convertToStringDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let dateString = dateFormatter.string(from: self.toDate()!)
        return dateString
    }
}
