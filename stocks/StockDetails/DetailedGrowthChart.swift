//
//  DetailedGrowthChart.swift
//  Stocker
//
//  Created by Martin Peshevski on 9/11/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import Charts

class DetailedGrowthChart: UIStackView, AxisValueFormatter, ChartViewDelegate, UIGestureRecognizerDelegate {

    lazy var selectedValueLabel = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var percentChangeView = UILabel(font: UIFont.systemFont(ofSize: 15))
    lazy var selectedPeriodLabel = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .center, color: .systemGray2)
    lazy var selectedPeriodContainer: UIView = {
        let v = UIView()
        v.snp.makeConstraints { make in make.height.equalTo(40) }
        v.addSubview(selectedPeriodLabel)
        return v
    }()
    
    var models: [PeriodicFinancialModel] = []
    var set: LineChartDataSet = LineChartDataSet()
    
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
        addArrangedSubview(selectedValueLabel)
        addArrangedSubview(percentChangeView)
        addArrangedSubview(selectedPeriodContainer)
        addArrangedSubview(chart)
        selectedPeriodLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        selectedPeriodLabel.alpha = 0
        alignment = .fill
    }

    func setData(_ data: [(x: PeriodicFinancialModel, y: Double)]) {
        var entries: [ChartDataEntry] = []
        models = data.map { $0.0 }
        percentChangeView.text = models.totalValuePercentChanged
        percentChangeView.textColor = models.totalColor
        selectedValueLabel.text = models[safe: models.count - 1]?.stringValue
        
        for (index, val) in data.enumerated() {
            let entry = ChartDataEntry(x: Double(index), y: val.y, data: val.x)
            entries.append(entry)
        }
        set = LineChartDataSet(entries: entries)
        set.setColor(models.totalColor)
        set.drawValuesEnabled = false
        set.drawCirclesEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .systemGray2
        set.lineWidth = 2
        let data = LineChartData(dataSet: set)
        chart.data = data
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(value)".roundedWithAbbreviations
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let data = entry.data as? PeriodicFinancialModel else { return }
        if selectedPeriodLabel.alpha == 0 { selectedPeriodLabel.fadeIn() }
        selectedValueLabel.text = data.stringValue
        selectedPeriodLabel.text = data.period
        percentChangeView.text = models.valuePercentChangedFrom(item: data)
        percentChangeView.textColor = models.colorFrom(item: data)
        set.setColor(models.colorFrom(item: data))
        let chartData = LineChartData(dataSet: set)
        chart.data = chartData
        
        selectedPeriodLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            let left = highlight.xPx - (selectedPeriodLabel.frame.size.width / 2)
            let right = highlight.xPx + (selectedPeriodLabel.frame.size.width / 2)
            if left < 0 { make.centerX.equalTo((selectedPeriodLabel.frame.size.width / 2))}
            else if right > self.frame.size.width {
                make.centerX.equalTo(self.frame.size.width - (selectedPeriodLabel.frame.size.width / 2))
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
        selectedPeriodLabel.fadeOut()
        selectedValueLabel.text = models[safe: models.count - 1]?.stringValue
        percentChangeView.text = models.totalValuePercentChanged
        percentChangeView.textColor = models.totalColor
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
