//
//  String+.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

extension String {

    func toDate() -> Date? {
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSS",
            "yyyy-MM-dd'T'HH:mm:ss"
        ]

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "KST")

        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: self) {
                return date
            }
        }
        return Date()
    }

    func convertToStringDate() -> String? {
        guard let date = self.toDate() else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
