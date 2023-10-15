//
//  KeychainManager.swift
//  TwoHoSun
//
//  Created by 관식 on 10/16/23.
//

import Foundation

class KeychainManager {
    private func saveToken(key: String, token: String) -> Bool {
        let query: NSDictionary = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: key,
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
}
