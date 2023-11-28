//
//  APIConstants.swift
//  TwoHoSun
//
//  Created by 235 on 11/9/23.
//

import Foundation

enum APIConstants {
    enum NetworkHeaderKey: String {
        case contentType = "Content-Type"
        case authorization = "Authorization"
    }

    static let accept: String = "Accept"
    static let applicationXForm: String = "application/x-www-form-urlencoded; charset=UTF-8"
    static let applicationJSON = "application/json"
    static let multiPartForm = "multipart/form-data"
    static var headerWithOutToken: [String: String] {
        [NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON]
    }
    static var headerWithAuthorization: [String: String] {
        [
            NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON,
            NetworkHeaderKey.authorization.rawValue: "Bearer \(KeychainManager.shared.readToken(key: "accessToken") ?? "")"
        ]
    }
    static var headerXform: [String: String] {
        [
            NetworkHeaderKey.contentType.rawValue: APIConstants.applicationXForm
        ]
    }
    static var headerMultiPartForm: [String: String] {
        [
            NetworkHeaderKey.contentType.rawValue: APIConstants.multiPartForm,
            NetworkHeaderKey.authorization.rawValue: "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
        ]
    }
}
