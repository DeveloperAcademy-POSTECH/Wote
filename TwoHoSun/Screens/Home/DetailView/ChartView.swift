//
//  ChartView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/23/23.
//

import SwiftUI

struct ChartView: View {
    @State var currentPage: Int = 0
    let viewModel = ChartViewModel(postId: 301)
    
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
    private var total: Int {
        return viewModel.chartModel.genderChart.male.agree + viewModel.chartModel.genderChart.male.disagree + viewModel.chartModel.genderChart.female.agree + viewModel.chartModel.genderChart.female.disagree
    }
    
    private var genderChart: some View {
        VStack {
            Text("성별 통계")
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, 4)
            genderChartContent(label: "남자", data: viewModel.chartModel.genderChart.male)
            genderChartContent(label: "여자", data: viewModel.chartModel.genderChart.female)
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
                    gradeChartContent(label: "중1", data: viewModel.chartModel.gradeChart.middleFirst)
                    gradeChartContent(label: "중2", data: viewModel.chartModel.gradeChart.middleSecond)
                    gradeChartContent(label: "중3", data: viewModel.chartModel.gradeChart.middleThird)
                    gradeChartContent(label: "고1", data: viewModel.chartModel.gradeChart.highFirst)
                    gradeChartContent(label: "고2", data: viewModel.chartModel.gradeChart.highSecond)
                    gradeChartContent(label: "고3", data: viewModel.chartModel.gradeChart.highThird)
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
                    regionChartContent(label: "서울", data: viewModel.chartModel.regionChart.seoul)
                    regionChartContent(label: "경기", data: viewModel.chartModel.regionChart.gyeonggi)
                    regionChartContent(label: "충청", data: viewModel.chartModel.regionChart.chungcheong)
                    regionChartContent(label: "강원", data: viewModel.chartModel.regionChart.gangwon)
                    regionChartContent(label: "경상", data: viewModel.chartModel.regionChart.gyeongsang)
                    regionChartContent(label: "전라", data: viewModel.chartModel.regionChart.jeolla)
                    regionChartContent(label: "제주", data: viewModel.chartModel.regionChart.jeju)
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
            Text(String(format: "%.1f%%", Double(data.disagree) / Double(total) * 100))
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
