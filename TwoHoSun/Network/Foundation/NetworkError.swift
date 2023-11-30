//
//  NetworkError.swift
//  TwoHoSun
//
//  Created by 235 on 11/10/23.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case bodyMissing
    case invalidType
    case parameterMissing
    case jsonParseException
    case forbiddenException
    case noMember
    case noPost
    case noComment
    case exipredJWT
    case unsupportedJWT
    case emptyClaims
    case notCompletedSignup
    case insertError
    case updateError
    case deleteError
    case nicknameDuplicate
    case reviewDuplicate
    case shouldgoLogin

    init(divisionCode: String) {
        switch divisionCode {
        case "G001":
            self = .badRequest
        case "G002":
            self = .bodyMissing
        case "G003":
            self = .invalidType
        case "G004":
            self = .parameterMissing
        case "G006":
            self = .jsonParseException
        case "G010":
            self = .forbiddenException
        case "E001":
            self = .noMember
        case "E002":
            self = .noPost
        case "E003":
            self = .noComment
        case "E004",
            "E005",
            "E006":
            self = .exipredJWT
        case "E007":
            self = .unsupportedJWT
        case "E008":
            self = .emptyClaims
        case "E009":
            self = .notCompletedSignup
        case "E010":
            self = .insertError
        case "E011":
            self = .updateError
        case "E012":
            self = .deleteError
        case "E013":
            self = .nicknameDuplicate
        case "E014":
            self = .reviewDuplicate
        default:
            // Handle unknown division codes or other cases if necessary
            fatalError("Unknown division code: \(divisionCode)")
        }
    }

    var errorDescription: String {
        switch self {
        case .noMember, .noPost:
            return "삭제된 게시글입니다."
        default:
            return "error "
        }
    }
}
