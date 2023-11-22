//
//  NotificationListCell.swift
//  TwoHoSun
//
//  Created by 235 on 11/22/23.
//

import Foundation

struct NotificationModel: Identifiable {
//    var id: ObjectIdentifier
    let id = UUID()
    let profileImage: String
    let contents: String
    let time: Int
    let postImage: String?
}
