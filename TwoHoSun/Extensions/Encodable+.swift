//
//  Encodable+.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Foundation

extension Encodable {

    func asParameter() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
