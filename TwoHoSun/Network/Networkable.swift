//
//  Networkable.swift
//  TwoHoSun
//
//  Created by 235 on 11/10/23.
//

import Moya

protocol Networkable {
    associatedtype Target: TargetType
    static func makeProvider() -> MoyaProvider<Target>
}
extension Networkable {
    static func makeProvider() -> MoyaProvider<Target> {
        let authPlugin = AccessTokenPlugin { _ in
            return "Bearer \(KeychainManager.shared.readToken(key: "accessToken")!)"
        }
        let loggerPlugin = NetworkLoggerPlugin()
        return MoyaProvider<Target>(plugins: [authPlugin,loggerPlugin])
    }
}
