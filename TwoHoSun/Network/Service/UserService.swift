//
//  UserService.swift
//  TwoHoSun
//
//  Created by 김민 on 11/13/23.
//

import Foundation
import Moya
import UIKit

enum UserService {
    case postAuthorCode(authorization: String)
    case checkNicknameValid(nickname: String)
    case postProfileSetting(profile: ProfileSetting)
    case refreshToken
    case putConsumerType(consumertype: ConsumerType)
    case getProfile
    case requestLogout
    case deleteUser
}

extension UserService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConst.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postAuthorCode:
            return "/login/oauth2/code/apple"
        case .checkNicknameValid:
            return "/api/profiles/isValidNickname"
        case .postProfileSetting:
            return "/api/profiles"
        case .refreshToken:
            return "/api/auth/refresh"
        case .putConsumerType:
            return "/api/profiles/consumerType"
        case .getProfile:
            return "/api/profiles"
        case .requestLogout:
            return "/api/auth/logout"
        case .deleteUser:
            return "/api/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .putConsumerType:
            return .put
        case .getProfile:
            return .get
        case .requestLogout:
            return .post
        case .deleteUser:
            return .delete
        default:
            return .post
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .postAuthorCode(let authorization):
           return ["state": "test",
                   "code": authorization]
        case .checkNicknameValid(let nickname):
            return ["nickname": nickname]
        case .postProfileSetting:
            return [:]
        case .refreshToken:
            return ["refreshToken": KeychainManager.shared.readToken(key: "refreshToken")!,
                    "identifier": KeychainManager.shared.readToken(key: "identifier")!]
        case .putConsumerType(let consumerType):
            return ["consumerType": consumerType.rawValue]
        case .getProfile:
            return [:]
        case .requestLogout:
            return [:]
        case .deleteUser:
            return [:]
        }
    }

    var task: Moya.Task {
        switch self {
        case .checkNicknameValid:
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        case .postProfileSetting(let profile):
            var formData: [MultipartFormData] = []

            if let data = UIImage(data: profile.imageFile ?? Data())?
                                            .jpegData(compressionQuality: 0.3) {
                let imageData = MultipartFormData(provider: .data(data),
                                                  name: "imageFile",
                                                  fileName: "\(profile.nickname).jpg",
                                                  mimeType: "image/jpeg")
                formData.append(imageData)
            }
            var profileData: [String: Any] = [
                 "nickname": profile.nickname
             ]
            if profile.school != nil {
                profileData["school"] = [
                    "schoolName": profile.school?.schoolName,
                    "schoolRegion": profile.school?.schoolRegion
                 ]
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: profileData)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                let stringData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!),
                                                   name: "profileRequest",
                                                   mimeType: "application/json")
                formData.append(stringData)
            } catch {
                print("error")
            }
            return .uploadMultipart(formData)
        case .putConsumerType:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getProfile:
            return .requestPlain
        case .requestLogout:
            return .requestPlain
        case .deleteUser:
            return .requestPlain
        default:
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postAuthorCode:
            APIConstants.headerXform
        case .postProfileSetting:
            APIConstants.headerMultiPartForm
        case .refreshToken:
            APIConstants.headerWithOutToken
        default:
            APIConstants.headerWithAuthorization
        case .requestLogout:
            APIConstants.headerWithAuthorization
        case .deleteUser:
            APIConstants.headerWithAuthorization
        }
    }
}
