//
//  Date+.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

extension Date {
    func differenceCurrentTime() -> [timeCalendar: Int] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .month, .year], from: self, to: .now)
        if let year = components.year, year > 0  {
            return [.year : year]
        } else if let month = components.month, month > 0 {
            return [.month: month]
        } else if let day = components.day, day > 0 {
            return [.day: day]
        } else if let hour = components.hour, hour > 0 {
            return [.hour: hour]
        } else if let minutes = components.minute, minutes > 0 {
            return [.minutes: minutes]
        } else {
            return [.seconds: components.second!]
        }
    }
}


