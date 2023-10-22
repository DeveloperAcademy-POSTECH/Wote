//
//  ChartView.swift
//  TwoHoSun
//
//  Created by 관식 on 10/23/23.
//

import SwiftUI

struct ChartView: View {
    var body: some View {
        TabView {
            genderChart
            genderChart
            genderChart
        }
        .tabViewStyle(.page)
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
        .padding(.horizontal, 26)
    }
    
    private var gradeChart: some View {
        VStack {
            Text("성별 통계")
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, 4)
            gradeChartContent()
        }
    }
    
    private func gradeChartContent() -> some View {
        HStack {
            Text("20.0%(2명)")
            Rectangle()
                .foregroundStyle(.cyan)
                .frame(height: 15)
        }
    }
}

#Preview {
    ChartView()
}
