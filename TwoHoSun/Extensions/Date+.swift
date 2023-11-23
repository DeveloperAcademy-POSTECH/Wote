//
//  Date+.swift
//  TwoHoSun
//
//  Created by 235 on 10/22/23.
//

import Foundation

extension Date {
    enum TimeCalendar {
        case year
        case month
        case day
        case hour
        case minutes
        case seconds
        var beforeString: String {
            switch self {
            case .year:
                return "년전"
            case .month:
                return "개월전"
            case .day:
                return "일전"
            case .hour:
                return "시간전"
            case .minutes:
                return "분전"
            case .seconds:
                return "초전"
            }
        }
    }
    func differenceCurrentTime() -> (String, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: self, to: .now)
//        if let year = components.year, year > 0  {
//            return [.year : year]
//        } else if let month = components.month, month > 0 {
//            return [.month: month]
//        } else 
        if let day = components.day, day > 0 {
            return (TimeCalendar.day.beforeString, day)
        } else if let hour = components.hour, hour > 0 {
            return (TimeCalendar.hour.beforeString, hour)
        } else if let minutes = components.minute, minutes > 0 {
            return (TimeCalendar.minutes.beforeString, minutes)
        } else {
            return (TimeCalendar.seconds.beforeString, components.second!)
        }
    }
}
