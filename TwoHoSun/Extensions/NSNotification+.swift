//
//  NSNotification+.swift
//  TwoHoSun
//
//  Created by 김민 on 11/23/23.
//

import Foundation

extension NSNotification {
    static let reviewStateUpdated = Notification.Name.init("ReviewCreated")
    static let voteStateUpdated = Notification.Name.init("voteStateUpdated")
    static let userBlockStateUpdated = Notification.Name.init("UserBlockStateUpdated")
}
