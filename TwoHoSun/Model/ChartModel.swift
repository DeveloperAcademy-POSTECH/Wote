//
//  ChartModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/23/23.
//

import Foundation

struct ChartModel {
    let genderChart: GenderChart
    let gradeChart: GradeChart
    let regionChart: RegionChart
}

struct GenderChart {
    let male: AgreeCount
    let female: AgreeCount
}

struct GradeChart {
    let middleFirst: AgreeCount
    let middleSecond: AgreeCount
    let middleThird: AgreeCount
    let highFirst: AgreeCount
    let highSecond: AgreeCount
    let highThird: AgreeCount
}

struct RegionChart {
    let seoul: AgreeCount
    let gyeonggi: AgreeCount
    let chungcheong: AgreeCount
    let gangwon: AgreeCount
    let gyeongsang: AgreeCount
    let jeolla: AgreeCount
    let jeju: AgreeCount
}

struct AgreeCount {
    let agree: Int
    let disagree: Int
}
