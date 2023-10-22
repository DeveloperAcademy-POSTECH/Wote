//
//  ChartView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/23/23.
//

import SwiftUI

struct ChartView: View {
    @State var currentPage: Int = 0
    
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
            genderChartContent("남자")
            genderChartContent("여자")
        }
        .padding(.horizontal, 26)
    }
    
    private func genderChartContent(_ gender: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(.secondarySystemBackground))
                .clipShape(.rect(cornerRadius: 10))
            HStack(alignment: .top, spacing: 12) {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 4) {
                    Text(gender)
                        .font(.system(size: 14, weight: .bold))
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundStyle(.cyan)
                        Rectangle()
                            .foregroundStyle(.green)
                    }
                    .frame(height: 15)
                    HStack {
                        Text("20.0%(2명)")
                        Spacer()
                        Text("80.0%(8명)")
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
                    gradeChartContent("중1")
                    gradeChartContent("중2")
                    gradeChartContent("중3")
                    gradeChartContent("고1")
                    gradeChartContent("고2")
                    gradeChartContent("고3")
                }
                .padding(12)
            }
        }
        .padding(.horizontal, 26)
    }
    
    private func gradeChartContent(_ grade: String) -> some View {
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
            Text(grade)
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
            Text("20.0%\n(2명)")
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
            Text("20.0%\n(2명)")
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
