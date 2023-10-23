//
//  VoteInfoModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/23/23.
//

import Foundation

struct VoteInfo: Codable {
    let grade: Int
    let regionType: RegionType
    let schoolType: SchoolType
    let gender: Gender
    let agree: Bool
}

enum RegionType: String, Codable {
    case seoul = "서울"
    case busan = "부산"
    case daegu = "대구"
    case incheon = "인천"
    case gwangju = "광주"
    case daejeon = "대전"
    case ulsan = "울산"
    case sejong = "세종"
    case gyeonggi = "경기"
    case gangwon = "강원"
    case chungbuk = "충북"
    case chungnam = "충남"
    case jeonbuk = "전북"
    case jeonnam = "전남"
    case gyeongbuk = "경북"
    case gyeongnam = "경남"
    case jeju = "제주"
}

enum SchoolType: String, Codable {
    case middleSchool = "중학교"
    case highSchool = "고등학교"
}

enum Gender: String, Codable {
    case male = "남"
    case female = "여"
}
