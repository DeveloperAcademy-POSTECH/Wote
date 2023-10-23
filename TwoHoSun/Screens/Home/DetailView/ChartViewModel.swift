//
//  ChartViewModel.swift
//  TwoHoSun
//
//  Created by 관식 on 10/23/23.
//

import Foundation
import Observation

@Observable
class ChartViewModel {
    var postId: Int
    var chartModel: ChartModel = ChartModel(genderChart: GenderChart(male: AgreeCount(agree: 0, disagree: 0), female: AgreeCount(agree: 0, disagree: 0)), gradeChart: GradeChart(middleFirst: AgreeCount(agree: 0, disagree: 0), middleSecond: AgreeCount(agree: 0, disagree: 0), middleThird: AgreeCount(agree: 0, disagree: 0), highFirst: AgreeCount(agree: 0, disagree: 0), highSecond: AgreeCount(agree: 0, disagree: 0), highThird: AgreeCount(agree: 0, disagree: 0)), regionChart: RegionChart(seoul: AgreeCount(agree: 0, disagree: 0), gyeonggi: AgreeCount(agree: 0, disagree: 0), chungcheong: AgreeCount(agree: 0, disagree: 0), gangwon: AgreeCount(agree: 0, disagree: 0), gyeongsang: AgreeCount(agree: 0, disagree: 0), jeolla: AgreeCount(agree: 0, disagree: 0), jeju: AgreeCount(agree: 0, disagree: 0)))
    
    init(postId: Int) {
        self.postId = postId
        getDetailPost(postId: postId)
    }
    
    func getDetailPost(postId: Int) {
        APIManager.shared.requestAPI(type: .getDetailPost(postId: postId)) { (response: GeneralResponse<PostResponse>) in
            switch response.status {
            case 401:
                APIManager.shared.refreshAllTokens()
                self.getDetailPost(postId: postId)
            case 200:
                guard let data = response.data else { return }
                print(data)
//                let summary = self.summarizeVotes(voteInfo: data.voteInfoList)
//                print(summary)
//                let chartModel = self.summarizeToChartModel(summary: summary)
//                self.chartModel = chartModel
//                print("CHARTMODEL: \(chartModel)")
            default:
                print("chart data error")
            }
        }
    }
    
    func summarizeVotes(voteInfo: [VoteInfo]) -> VoteSummary {
        var summary = VoteSummary(gender: [:], grade: [:], region: [:], schoolAndGrade: [:])
        
        voteInfo.forEach { vote in
            let agreeCount = vote.agree ? 1 : 0
            let disagreeCount = vote.agree ? 0 : 1
            
            // Gender
            summary.gender[vote.gender.rawValue, default: AgreeCount(agree: 0, disagree: 0)].agree += agreeCount
            summary.gender[vote.gender.rawValue, default: AgreeCount(agree: 0, disagree: 0)].disagree += disagreeCount
            
            // Region
            let region = mapRegion(regionType: vote.regionType.rawValue)
            summary.region[region, default: AgreeCount(agree: 0, disagree: 0)].agree += agreeCount
            summary.region[region, default: AgreeCount(agree: 0, disagree: 0)].disagree += disagreeCount
            
            // School and Grade
            let schoolAndGradeKey = "\(vote.schoolType.rawValue) \(vote.grade)"
            summary.schoolAndGrade[schoolAndGradeKey, default: AgreeCount(agree: 0, disagree: 0)].agree += agreeCount
            summary.schoolAndGrade[schoolAndGradeKey, default: AgreeCount(agree: 0, disagree: 0)].disagree += disagreeCount
        }
        
        return summary
    }
    
    func summarizeToChartModel(summary: VoteSummary) -> ChartModel {
        let genderChart = GenderChart(
            male: summary.gender["남"] ?? AgreeCount(agree: 0, disagree: 0),
            female: summary.gender["여"] ?? AgreeCount(agree: 0, disagree: 0)
        )
        
        let gradeChart = GradeChart(
            middleFirst: summary.schoolAndGrade["중학교 1"] ?? AgreeCount(agree: 0, disagree: 0),
            middleSecond: summary.schoolAndGrade["중학교 2"] ?? AgreeCount(agree: 0, disagree: 0),
            middleThird: summary.schoolAndGrade["중학교 3"] ?? AgreeCount(agree: 0, disagree: 0),
            highFirst: summary.schoolAndGrade["고등학교 1"] ?? AgreeCount(agree: 0, disagree: 0),
            highSecond: summary.schoolAndGrade["고등학교 2"] ?? AgreeCount(agree: 0, disagree: 0),
            highThird: summary.schoolAndGrade["고등학교 3"] ?? AgreeCount(agree: 0, disagree: 0)
        )
        
        let regionChart = RegionChart(
            seoul: summary.region["Seoul"] ?? AgreeCount(agree: 0, disagree: 0),
            gyeonggi: summary.region["Gyeonggi"] ?? AgreeCount(agree: 0, disagree: 0),
            chungcheong: summary.region["Chungcheong"] ?? AgreeCount(agree: 0, disagree: 0),
            gangwon: summary.region["Gangwon"] ?? AgreeCount(agree: 0, disagree: 0),
            gyeongsang: summary.region["Gyeongsang"] ?? AgreeCount(agree: 0, disagree: 0),
            jeolla: summary.region["Jeolla"] ?? AgreeCount(agree: 0, disagree: 0),
            jeju: summary.region["Jeju"] ?? AgreeCount(agree: 0, disagree: 0)
        )
        
        return ChartModel(genderChart: genderChart, gradeChart: gradeChart, regionChart: regionChart)
    }
    
    func mapRegion(regionType: String) -> String {
        switch regionType {
        case "경북", "경남", "울산", "부산", "대구":
            return "Gyeongsang"
        case "충북", "충남", "대전", "세종": 
            return "Chungcheong"
        case "전남", "전북", "광주":
            return "Jeolla"
        case "인천", "경기":
            return "Gyeonggi"
        case "서울": 
            return "Seoul"
        case "제주": 
            return "Jeju"
        default: 
            return "Unknown"
        }
    }
}
