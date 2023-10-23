//
//  ChartView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/23/23.
//

import SwiftUI

struct ChartView: View {
    @State var currentPage: Int = 0

    let viewModel = ChartViewModel()
    let model = ChartModel(
        genderChart: GenderChart(male: AgreeCount(agree: 14, disagree: 26), female: AgreeCount(agree: 54, disagree: 6)),
        gradeChart: GradeChart(middleFirst: AgreeCount(agree: 12, disagree: 4), middleSecond: AgreeCount(agree: 2, disagree: 6), middleThird: AgreeCount(agree: 11, disagree: 4), highFirst: AgreeCount(agree: 20, disagree: 2), highSecond: AgreeCount(agree: 9, disagree: 4), highThird: AgreeCount(agree: 16, disagree: 10)),
        regionChart: RegionChart(seoul: AgreeCount(agree: 10, disagree: 4), gyeonggi: AgreeCount(agree: 1, disagree: 2), chungcheong: AgreeCount(agree: 2, disagree: 4), gangwon: AgreeCount(agree: 21, disagree: 9), gyeongsang: AgreeCount(agree: 5, disagree: 8), jeolla: AgreeCount(agree: 6, disagree: 4), jeju: AgreeCount(agree: 10, disagree: 14)))
    var total: Int {
        return model.genderChart.male.agree + model.genderChart.male.disagree + model.genderChart.female.agree + model.genderChart.female.disagree
    }
    
    var body: some View {
        VStack(spacing: 10) {
            TabView(selection: $currentPage) {
                genderChart
                    .tag(0)
                gradeChart
                    .tag(1)
                regionChart
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 200)
            horizontalScroll
        }
    }
}

extension ChartView {
    private var genderChart: some View {
        VStack {
            Text("성별 통계")
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, 4)
            genderChartContent(label: "남자", data: model.genderChart.male)
            genderChartContent(label: "여자", data: model.genderChart.female)
        }
        .padding(.horizontal, 26)
    }
    
    private func genderChartContent(label: String, data: AgreeCount) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(.secondarySystemBackground))
                .clipShape(.rect(cornerRadius: 10))
            HStack(alignment: .top, spacing: 12) {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.system(size: 14, weight: .bold))
                    GeometryReader { geo in
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundStyle(.cyan)
                                .frame(width: geo.size.width * Double(data.agree) / Double(data.agree + data.disagree))
                            Rectangle()
                                .foregroundStyle(.green)
                        }
                    }
                    .frame(height: 15)
                    HStack {
                        Text(String(format: "%.1f%%", Double(data.agree) / Double(total) * 100) + "(\(data.agree))명")
                            .fixedSize()
                        Spacer()
                        Text(String(format: "%.1f%%", Double(data.disagree) / Double(total) * 100) + "(\(data.disagree))명")
                            .fixedSize()
                    }
                    .foregroundStyle(.gray)
                    .font(.system(size: 12, weight: .medium))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    private var gradeChart: some View {
        VStack(spacing: 12) {
            Text("학년별 통계")
                .font(.system(size: 16, weight: .bold))
            ZStack {
                Rectangle()
                    .foregroundStyle(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: 10))
                VStack {
                    gradeChartContent(label: "중1", data: model.gradeChart.middleFirst)
                    gradeChartContent(label: "중2", data: model.gradeChart.middleSecond)
                    gradeChartContent(label: "중3", data: model.gradeChart.middleThird)
                    gradeChartContent(label: "고1", data: model.gradeChart.highFirst)
                    gradeChartContent(label: "고2", data: model.gradeChart.highSecond)
                    gradeChartContent(label: "고3", data: model.gradeChart.highThird)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
            }
        }
        .padding(.horizontal, 26)
    }
    
    private func gradeChartContent(label: String, data: AgreeCount) -> some View {
            HStack {
                HStack {
                    Spacer()
                    Text(String(format: "%.1f%%", Double(data.agree) / Double(total) * 100))
                        .foregroundStyle(.gray)
                        .font(.system(size: 12, weight: .medium))
                        .fixedSize()
                    Rectangle()
                        .foregroundStyle(.cyan)
                        .frame(width: 90 * Double(data.agree) / Double(total), height: 15)
                }
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                HStack {
                    Rectangle()
                        .foregroundStyle(.green)
                        .frame(width: 90 * Double(data.disagree) / Double(total), height: 15)
                    Text(String(format: "%.1f%%", Double(data.disagree) / Double(total) * 100))
                        .foregroundStyle(.gray)
                        .font(.system(size: 12, weight: .medium))
                        .fixedSize()
                    Spacer()
                }
            }
    }
    
    private var regionChart: some View {
        VStack(spacing: 12) {
            Text("지역별 통계")
                .font(.system(size: 16, weight: .bold))
            ZStack {
                Rectangle()
                    .foregroundStyle(Color(.secondarySystemBackground))
                    .clipShape(.rect(cornerRadius: 10))
                HStack(spacing: 14) {
                    regionChartContent(label: "서울", data: model.regionChart.seoul)
                    regionChartContent(label: "경기", data: model.regionChart.gyeonggi)
                    regionChartContent(label: "충청", data: model.regionChart.chungcheong)
                    regionChartContent(label: "강원", data: model.regionChart.gangwon)
                    regionChartContent(label: "경상", data: model.regionChart.gyeongsang)
                    regionChartContent(label: "전라", data: model.regionChart.jeolla)
                    regionChartContent(label: "제주", data: model.regionChart.jeju)
                }
                .padding(12)
            }
        }
        .padding(.horizontal, 26)
    }
    
    private func regionChartContent(label: String, data: AgreeCount) -> some View {
        VStack {
            Text(String(format: "%.1f%%", Double(data.agree) / Double(total) * 100))
                .foregroundStyle(.gray)
                .font(.system(size: 12, weight: .medium))
                .fixedSize()
                .multilineTextAlignment(.center)
            Rectangle()
                .foregroundStyle(.cyan)
                .frame(width: 15, height: 40 * Double(data.agree) / Double(total))
            Text(label)
                .font(.system(size: 14, weight: .medium))
            Rectangle()
                .foregroundStyle(.green)
                .frame(width: 15, height: 40 * Double(data.disagree) / Double(total))
            Text(String(format: "%.1f%%", Double(data.agree) / Double(total) * 100))
                .foregroundStyle(.gray)
                .font(.system(size: 12, weight: .medium))
                .fixedSize()
                .multilineTextAlignment(.center)
        }
    }
    
    private var horizontalScroll: some View {
        HStack {
            ForEach(0..<3) { idx in
                if idx == currentPage {
                    Rectangle()
                        .frame(width: 28,height: 9)
                        .foregroundStyle(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 21))
                } else {
                    Circle().frame(width: 8, height: 8)
                        .foregroundStyle(Color(.secondarySystemFill))
                }
            }
        }
    }
}

#Preview {
    ChartView()
}
