//
//  KeychainManager.swift
//  TwoHoSun
//
//  Created by 관식 on 10/16/23.
//

import Foundation

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func saveToken(key: String, token: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: key,
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)
        print("save result of \(key): \(SecItemAdd(query as CFDictionary, nil) == errSecSuccess)")
    }
    
    func readToken(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            return nil
        }
    }
    
//    func updateToken(key: String, token: String) {
//        let previousQuery: NSDictionary = [
//            kSecClass: kSecClassInternetPassword,
//            kSecAttrAccount: key
//        ]
//        let updateQuery: NSDictionary = [
//            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any
//        ]
//    }
//    
    func deleteToken(key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(query)
    }
}
