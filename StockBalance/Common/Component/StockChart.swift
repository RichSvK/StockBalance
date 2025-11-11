//
//  StockChart.swift
//  StockBalance
//
//  Created by Richard Sugiharto on 11/11/25.
//

import Charts
import SwiftUI

struct StockChart: View {
    var series: [StockSeries] = []
    
    var body: some View {
        Chart {
            ForEach(series) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value),
                    series: .value("Category", item.category)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(by: .value("Category", item.category))
            }
        }
        .frame(height: 400)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text(String(format: "%.0f%%", doubleValue))
                    }
                }
            }
        }
    }
}
