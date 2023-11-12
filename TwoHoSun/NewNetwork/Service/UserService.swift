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
    case postAuthorCode(auth: AuthCodeRequestDto)
    case checkNicknameValid(nickname: NicknameRequestDto)
    case postProfileSetting(profile: ProfileSetting)
    case refreshToken
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
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        do {
            switch self {
            case .postAuthorCode(let auth):
                return .requestParameters(parameters: try auth.asParameter(), encoding: URLEncoding.default)
            case .checkNicknameValid(let nickname):
                return .requestParameters(parameters: try nickname.asParameter(), encoding: JSONEncoding.default)
            case .postProfileSetting(let profile):
                var formData: [MultipartFormData] = []
                if let data = UIImage(data: profile.userProfileImage)?.jpegData(compressionQuality: 0.3) {
                    let imageData = MultipartFormData(provider: .data(data),
                                                      name: "imageFile",
                                                      fileName: "temp.jpg",
                                                      mimeType: "image/jpeg")
                    formData.append(imageData)
                }
                let json = try! JSONSerialization.data(withJSONObject: profile, options: [])
                let jsonString = String(data: json, encoding: .utf8)!
                let stringData = MultipartFormData(provider: .data(jsonString.data(using: String.Encoding.utf8)!),
                                                   name: "profileRequest",
                                                   mimeType: "application/json")
                formData.append(stringData)
                return .uploadMultipart(formData)
            case .refreshToken:
                return .requestPlain // TODO: 수정 필요
            }
        } catch {
            fatalError("Failed to convert parameters. Error: \(error)")
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postAuthorCode:
            APIConstants.headerXform
        case .checkNicknameValid:
            APIConstants.headerWithAuthorization
        case .postProfileSetting:
            APIConstants.headerMultiPartForm
        case .refreshToken:
            APIConstants.headerWithOutToken
        }
    }
}
