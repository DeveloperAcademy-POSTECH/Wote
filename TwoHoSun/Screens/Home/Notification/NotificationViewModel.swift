//
//  NotificationViewModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/22/23.
//

import Foundation
import SwiftUI

@Observable
class NotificationViewModel {
    var notisavedDatas: AppData
    var within24HoursData = [NotiDecodeModel]()
    var beyond24HoursData = [NotiDecodeModel]()
    init(notisavedDatas: AppData) {
        self.notisavedDatas = notisavedDatas
        self.separteDatabyDate()
    }

    func separteDatabyDate() {
        let today = Calendar.current.startOfDay(for: Date())
        let beforeDay = Calendar.current.date(byAdding: .hour, value: -24, to: today)!
        for data in notisavedDatas.notificationDatas {
            if beforeDay >= data.notitime.toDate()! {
                within24HoursData.append(data)
            } else {
                beyond24HoursData.append(data)
            }
        }
    }

}
