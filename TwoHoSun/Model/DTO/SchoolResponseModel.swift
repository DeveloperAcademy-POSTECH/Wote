//
//  SchoolResponseModel.swift
//  TwoHoSun
//
//  Created by 김민 on 10/17/23.
//

import Foundation

struct HighSchoolResponse: Codable {
    let dataSearch: HighSchoolData
}

struct HighSchoolData: Codable {
    let content: [HighSchoolContent]
}

struct HighSchoolContent: Codable, Hashable {
    let schoolType: String
    let link: String
    let schoolGubun: String
    let adres, schoolName, region, totalCount: String
    let estType: String
    let seq: String

    func convertToSchoolInfoModel() -> SchoolInfoModel {
        return SchoolInfoModel(school: SchoolModel(schoolName: schoolName,
                                                   schoolRegion: region),
                               schoolAddress: adres)
    }
}

struct MiddleSchoolResponse: Codable {
    let dataSearch: MiddleSchoolData
}

struct MiddleSchoolData: Codable {
    let content: [MiddleSchoolContent]
}

struct MiddleSchoolContent: Codable, Hashable {
    let link: String
    let adres, schoolName, region, totalCount: String
    let estType: String
    let seq: String

    func convertToSchoolInfoModel() -> SchoolInfoModel {
        return SchoolInfoModel(school: SchoolModel(schoolName: schoolName,
                                                   schoolRegion: region),
                               schoolAddress: adres)
    }
}

let regionMapping: [String: String] = [
    "서울특별시": "서울",
    "부산광역시": "부산",
    "인천광역시": "인천",
    "대구광역시": "대구",
    "광주광역시": "광주",
    "대전광역시": "대전",
    "울산광역시": "울산",
    "세종특별자치시": "세종",
    "경기도": "경기",
    "강원특별자치도": "강원",
    "충청남도": "충남",
    "충청북도": "충북",
    "경상북도": "경북",
    "경상남도": "경남",
    "전라북도": "전북",
    "전라남도": "전남",
    "제주특별자치도": "제주"
]
