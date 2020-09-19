//
//  PeriodicValueChangeViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

struct PeriodicFinancialModel {
    var period: String
    var value: Double
    var stringValue: String
    var percentChange: Double

    var percentChangeString: String { String.init(format: "%.2f%%", percentChange) }
    var percentColor: UIColor { percentChange < 0 ? UIColor.systemRed : UIColor.systemGreen }
    var image: UIImage { percentChange < 0 ? (UIImage(named: "down") ?? UIImage()).withRenderingMode(.alwaysTemplate):
        (UIImage(named: "up") ?? UIImage()).withRenderingMode(.alwaysTemplate) }
    
    var timestamp: Double? {
        let date = StockDateFormatter.shared.date(from: period)
        return date?.timeIntervalSince1970
    }
}

class PercentChangeKeyValueView: KeyValueView {
    lazy var percentLabel: UILabel = {
        let lbl = UILabel(font: UIFont.systemFont(ofSize: 12), alignment: .right)
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lbl
    }()
    lazy var percentImage: UIImageView = {
        let img = UIImageView()
        img.snp.makeConstraints { make in make.width.height.equalTo(24) }
        return img
    }()
    lazy var percentStack = UIStackView(views: [UIView(), percentImage, percentLabel], axis: .horizontal)

    lazy var valueStack = UIStackView(views: [], axis: .vertical, spacing: 5)
    init(model: PeriodicFinancialModel) {
        super.init(key: model.period, value: model.stringValue)
        valueLabel.removeFromSuperview()
        percentLabel.textColor = model.percentColor
        percentImage.tintColor = model.percentColor

        valueStack.addArrangedSubview(valueLabel)
        valueStack.addArrangedSubview(percentStack)

        addArrangedSubview(valueStack)
        setup(model: model)
    }
    
    func setup(model: PeriodicFinancialModel) {
        super.setup(key: model.period, value: model.stringValue)
        percentImage.image = model.image
        percentLabel.text = model.percentChangeString
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Collection where Iterator.Element == PeriodicFinancialModel {
    var totalPercentChange: Double {
        guard let first = first, first.value != 0.0, count > 0, let lastIndex = count-1 as? Self.Index else { return 0 }
        return ((self[lastIndex].value - first.value) / fabs(first.value)) * 100
    }
    
    var totalValueChange: Double {
        guard let first = first, count > 0, let lastIndex = count-1 as? Self.Index else { return 0 }
        return self[lastIndex].value - first.value
    }
    
    func percentChangedFrom(item: PeriodicFinancialModel) -> Double {
        guard let first = first, first.value != 0.0 else { return 0 }
        return ((item.value - first.value) / fabs(first.value)) * 100
    }
    
    func valueChangedFrom(item: PeriodicFinancialModel) -> Double {
        guard let first = first else { return 0 }
        return item.value - first.value
    }
    
    var totalValuePercentChanged: String {
        guard totalPercentChange != 0 else { return "\(totalValueChange)".roundedWithAbbreviations }
        return "\("\(totalValueChange)".roundedWithAbbreviations)(\("\(totalPercentChange)".twoDigits)%)"
    }
    
    func valuePercentChangedFrom(item: PeriodicFinancialModel) -> String {
        guard percentChangedFrom(item: item) != 0 else { return "\(valueChangedFrom(item: item))".roundedWithAbbreviations }
        return "\("\(valueChangedFrom(item: item))".roundedWithAbbreviations)(\("\(percentChangedFrom(item: item))".twoDigits)%)"
    }
    
    var totalColor: UIColor {
        totalValueChange > 0 ? .systemGreen : .systemRed
    }
    
    func colorFrom(item: PeriodicFinancialModel) -> UIColor {
        return valueChangedFrom(item: item) > 0 ? .systemGreen: .systemRed
    }
}

class PeriodicValueChangeViewController: StackViewController {
    let periodicChangeAnnual: [PeriodicFinancialModel]
    let periodicChangeQuarterly: [PeriodicFinancialModel]
    
    let metric: Metric
    
    lazy var chart = DetailedGrowthChart()
    lazy var chartDataAnnual: [(PeriodicFinancialModel, Double)] = {
        return periodicChangeAnnual.map { return ($0, $0.value) }.sorted { $0.0.timestamp ?? 0 < $1.0.timestamp ?? 0 }
    }()
    
    lazy var addButton = UIButton()
    
    lazy var chartDataQuarterly: [(PeriodicFinancialModel, Double)] = {
        return periodicChangeQuarterly.map { return ($0, $0.value) }.sorted { $0.0.timestamp ?? 0 < $1.0.timestamp ?? 0 }
    }()
    
    init(ticker: String, metricType: Metric, periodicChangeAnnual: [PeriodicFinancialModel], periodicChangeQuarterly: [PeriodicFinancialModel], isAnnual: Bool = true) {
        self.periodicChangeAnnual = periodicChangeAnnual
        self.periodicChangeQuarterly = periodicChangeQuarterly
        self.metric = metricType
        
        super.init()
        titleView.text = ticker
        subtitleView.text = metricType.text

        if let metricType = metric.metricType {
            let alreadyFavorited = UserDefaultsManager.shared.preferredMetrics.contains(metricType)
            addButton.setImage(UIImage(named: alreadyFavorited ? "checkmark-circle" : "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.tintColor = alreadyFavorited ? UIColor.systemGreen : UIColor.label
            addButton.addTarget(self, action: #selector(onAdd), for: .touchUpInside)
            addButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            titleViewStack.addArrangedSubview(addButton)
            addButton.snp.makeConstraints { make in make.width.height.equalTo(48) }
        }

        content.addArrangedSubview(picker)
        content.addArrangedSubview(chart)
        content.setCustomSpacing(25, after: chart)

        picker.addTarget(self, action: #selector(onPeriodChanged(sender:)), for: .valueChanged)
        
        if isAnnual {
            picker.selectedSegmentIndex = 0
            setupAnnual()
        } else {
            picker.selectedSegmentIndex = 1
            setupQuarterly()
        }
    }
    
    @objc
    private func onAdd() {
        guard let metricType = metric.metricType else { return }

        var preferredMetrics = UserDefaultsManager.shared.preferredMetrics
        let alreadyFavorited = preferredMetrics.contains(metricType)
        
        if let firstIndex = preferredMetrics.firstIndex(of: metricType), alreadyFavorited {
            preferredMetrics.remove(at: firstIndex)
            addButton.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.tintColor = UIColor.label
        } else {
            preferredMetrics.append(metricType)
            addButton.setImage(UIImage(named: "checkmark-circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.tintColor = UIColor.systemGreen
        }
        
        UserDefaultsManager.shared.preferredMetrics = preferredMetrics
    }
    
    @objc
    private func onPeriodChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: setupAnnual()
        case 1: setupQuarterly()
        default: return
        }
    }
    
    private func setupAnnual() {
        removeMetrics()
        chart.setData(chartDataAnnual)
        for metric in periodicChangeAnnual {
            let cell = PercentChangeKeyValueView(model: metric)
            content.addArrangedSubview(cell)
        }
    }
    
    private func setupQuarterly() {
        removeMetrics()
        chart.setData(chartDataQuarterly)
        for metric in periodicChangeQuarterly {
            let cell = PercentChangeKeyValueView(model: metric)
            content.addArrangedSubview(cell)
        }
    }
    
    private func removeMetrics() {
        for view in content.stockStack.arrangedSubviews where view.isKind(of: PercentChangeKeyValueView.self) {
            view.removeFromSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
