//
//  NotificationModel.swift
//  TwoHoSun
//
//  Created by 235 on 11/22/23.
//

import Foundation
struct NotiDecodeModel: Decodable {
    let postid: Int
    let aps: Aps
    let postStatus: String
    let authorProfile: String?
    let postImage: String?
    let isComment: Bool
    let notitime: String

    enum CodingKeys: String, CodingKey {
        case postid = "post_id"
        case aps
        case postStatus = "post_status"
        case authorProfile = "author_profile"
        case postImage = "post_image"
        case isComment = "is_comment"
        case notitime = "notification_time"
    }

}

struct Aps: Decodable {
    let alert: Alertbody
    let sound: String

}
struct Alertbody: Decodable {
    let subtitle: String
    let body: String
}
