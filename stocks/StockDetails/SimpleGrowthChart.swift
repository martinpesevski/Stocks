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

class DetailedGrowthChart: UIStackView, IAxisValueFormatter, ChartViewDelegate, UIGestureRecognizerDelegate {

    lazy var percentChangeView = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .center, color: .systemGray2)
    lazy var selectedValueLabel = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .center, color: .systemGray2)
    lazy var selectedValueContainer: UIView = {
        let v = UIView()
        v.snp.makeConstraints { make in make.height.equalTo(40) }
        v.addSubview(selectedValueLabel)
        return v
    }()
    
    lazy var chart: LineChartView = {
        let c = LineChartView()
        c.snp.makeConstraints { make in
            make.height.equalTo(150)
        }

        c.legend.enabled = false
        c.rightAxis.enabled = false
        c.leftAxis.enabled = false
        c.dragEnabled = true
        c.pinchZoomEnabled = false
        c.doubleTapToZoomEnabled = false
        c.scaleXEnabled = false
        c.scaleYEnabled = false
        c.highlightPerDragEnabled = true
        c.drawGridBackgroundEnabled = false
        c.isUserInteractionEnabled = true
        c.xAxis.drawGridLinesEnabled = false
        c.xAxis.drawAxisLineEnabled = false
        c.xAxis.drawLabelsEnabled = false
        c.leftAxis.valueFormatter = self
        c.delegate = self
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanEnded(recognizer:)))
        panRecognizer.delegate = self
        c.addGestureRecognizer(panRecognizer)
        
        return c
    }()
    
    init() {
        super.init(frame: .zero)
        
        axis = .vertical
        addArrangedSubview(percentChangeView)
        addArrangedSubview(selectedValueContainer)
        addArrangedSubview(chart)
        selectedValueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        selectedValueLabel.alpha = 0
    }

    func setData(_ data: [(x: PeriodicFinancialModel, y: Double)]) {
        var entries: [ChartDataEntry] = []
        var colors: [NSUIColor] = []

        for (index, val) in data.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: val.y, data: val.x)
            entries.append(entry)
            colors.append(UIColor.systemGreen)
        }
        let set = LineChartDataSet(entries: entries)
        set.setColors(colors, alpha: 1)
        set.drawValuesEnabled = false
        set.drawCirclesEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .systemGray2
        let data = LineChartData(dataSet: set)
        chart.data = data
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(value)".roundedWithAbbreviations
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let data = entry.data as? PeriodicFinancialModel else { return }
        if selectedValueLabel.alpha == 0 { selectedValueLabel.fadeIn() }
        selectedValueLabel.text = data.period
        percentChangeView.text = data.stringValue
        selectedValueLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            let left = highlight.xPx - (selectedValueLabel.frame.size.width / 2)
            let right = highlight.xPx + (selectedValueLabel.frame.size.width / 2)
            if left < 0 { make.centerX.equalTo((selectedValueLabel.frame.size.width / 2))}
            else if right > self.frame.size.width {
                make.centerX.equalTo(self.frame.size.width - (selectedValueLabel.frame.size.width / 2))
            } else {
                make.centerX.equalTo(highlight.xPx)
            }
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        stopHighlighting()
    }
    
    @objc
    func onPanEnded(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            stopHighlighting()
        }
    }
    
    func stopHighlighting() {
        chart.highlightValue(nil)
        selectedValueLabel.fadeOut()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
