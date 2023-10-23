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
        genderChart: GenderChart(male: AgreeCount(agree: 21, disagree: 12), female: AgreeCount(agree: 4, disagree: 9)),
        gradeChart: GradeChart(middleFirst: AgreeCount(agree: 3, disagree: 2), middleSecond: AgreeCount(agree: 23, disagree: 11), middleThird: AgreeCount(agree: 15, disagree: 2), highFirst: AgreeCount(agree: 4, disagree: 9), highSecond: AgreeCount(agree: 32, disagree: 12), highThird: AgreeCount(agree: 49, disagree: 9)),
        regionChart: RegionChart(seoul: AgreeCount(agree: 32, disagree: 13), gyeonggi: AgreeCount(agree: 23, disagree: 12), chungcheong: AgreeCount(agree: 18, disagree: 7), gangwon: AgreeCount(agree: 4, disagree: 8), gyeongsang: AgreeCount(agree: 8, disagree: 8), jeolla: AgreeCount(agree: 27, disagree: 21), jeju: AgreeCount(agree: 2, disagree: 9)))
    
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
                        Text(String(format: "%.1f", Double(data.agree) / Double(data.agree + data.disagree) * 100) + "%(\(data.agree))명")
                            .fixedSize()
                        Spacer()
                        Text(String(format: "%.1f", Double(data.disagree) / Double(data.agree + data.disagree) * 100) + "%(\(data.disagree))명")
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
                .padding(12)
            }
        }
        .padding(.horizontal, 26)
    }
    
    private func gradeChartContent(label: String, data: AgreeCount) -> some View {
        HStack {
            HStack {
                Spacer()
                Text("20.0%(2명)")
                    .foregroundStyle(.gray)
                    .font(.system(size: 12, weight: .medium))
                    .fixedSize()
                Rectangle()
                    .foregroundStyle(.cyan)
                    .frame(height: 15)
            }
            Text(label)
                .font(.system(size: 14, weight: .medium))
            HStack {
                Rectangle()
                    .foregroundStyle(.green)
                    .frame(height: 15)
                Text("20.0%(2명)")
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
                HStack(spacing: 12) {
                    regionChartContent("서울")
                    regionChartContent("경기")
                    regionChartContent("충청")
                    regionChartContent("강원")
                    regionChartContent("경상")
                    regionChartContent("전라")
                    regionChartContent("제주")
                }
                .padding(12)
            }
        }
        .padding(.horizontal, 26)
    }
    
    private func regionChartContent(_ region: String) -> some View {
        VStack {
            Text("20.0%\n(\(model.genderChart.male.agree)명)")
                .foregroundStyle(.gray)
                .font(.system(size: 10, weight: .medium))
                .fixedSize()
                .multilineTextAlignment(.center)
            Rectangle()
                .foregroundStyle(.cyan)
                .frame(width: 15)
            Text(region)
                .font(.system(size: 14, weight: .medium))
            Rectangle()
                .foregroundStyle(.green)
                .frame(width: 15)
            Text("20.0%\n(\(model.genderChart.male.disagree)명)")
                .foregroundStyle(.gray)
                .font(.system(size: 10, weight: .medium))
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
