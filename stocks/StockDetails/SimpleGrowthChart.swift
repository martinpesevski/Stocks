//
//  SimpleGrowthChart.swift
//  stocks
//
//  Created by Martin Peshevski on 4/15/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import Charts

class SimpleGrowthChart: BarChartView {

    override init(frame: CGRect) {
        super.init(frame: .zero)

        snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(50)
        }

        legend.enabled = false
        rightAxis.enabled = false
        leftAxis.enabled = false
        dragEnabled = true
        pinchZoomEnabled = false
        doubleTapToZoomEnabled = false
        scaleXEnabled = false
        scaleYEnabled = false
        highlightPerDragEnabled = false
        drawBarShadowEnabled = false
        drawValueAboveBarEnabled = false
        drawGridBackgroundEnabled = false
        isUserInteractionEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = false
    }

    func setData(_ data: [Double]) {
        var entries: [BarChartDataEntry] = []
        var colors: [NSUIColor] = []
        for (index, number) in data.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: number)
            entries.append(entry)
            colors.append(number >= 0 ? UIColor.systemGreen : UIColor.systemRed)
        }
        let set = BarChartDataSet(entries: entries)
        set.setColors(colors, alpha: 1)
        set.drawValuesEnabled = false
        let data = BarChartData(dataSet: set)
        data.barWidth = 0.8
        self.data = data
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
