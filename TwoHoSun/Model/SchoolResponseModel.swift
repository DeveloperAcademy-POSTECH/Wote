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
//        return SchoolInfoModel(school: <#SchoolModel#>, schoolName: schoolName,
//                               schoolRegion: region,
//                               schoolAddress: adres)
        return SchoolInfoModel(school: SchoolModel(schoolName: schoolName,
                                                   schoolRegion: region,
                                                   schoolType: SchoolType.highSchool.schoolType),
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
//        return SchoolInfoModel(schoolName: schoolName,
//                               schoolRegion: region,
//                               schoolAddress: adres)
        return SchoolInfoModel(school: SchoolModel(schoolName: schoolName,
                                                   schoolRegion: region,
                                                   schoolType: SchoolType.middleSchool.schoolType),
                               schoolAddress: adres)
    }
}
