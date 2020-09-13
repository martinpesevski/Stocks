//
//  BalanceSheetTable.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class BalanceSheetViewController: StackViewController, MetricKeyValueDelegate {
    let balanceSheetsAnnual: [BalanceSheet]
    let balanceSheetsQuarterly: [BalanceSheet]

    let metricsAnnual: [BalanceSheetFinancialMetric]
    let metricsQuarterly: [BalanceSheetFinancialMetric]
    
    init(balanceSheetsAnnual: [BalanceSheet], balanceSheetsQuarterly: [BalanceSheet]) {
        self.balanceSheetsAnnual = balanceSheetsAnnual
        self.balanceSheetsQuarterly = balanceSheetsQuarterly
        
        self.metricsAnnual = balanceSheetsAnnual[safe: 0]?.metrics as? [BalanceSheetFinancialMetric] ?? []
        self.metricsQuarterly = balanceSheetsQuarterly[safe: 0]?.metrics as? [BalanceSheetFinancialMetric] ?? []
        
        super.init()
        titleView.text = balanceSheetsAnnual.symbol
        subtitleView.text = "Balance sheet"
        
        content.addArrangedSubview(picker)
        content.setCustomSpacing(25, after: picker)

        picker.addTarget(self, action: #selector(onPeriodChanged(sender:)), for: .valueChanged)
        
        setupAnnual()
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
        for metric in metricsAnnual {
            let cell = MetricKeyValueView(metric: metric)
            cell.valueLabel.text = balanceSheetsAnnual.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(balanceSheetsAnnual.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    private func setupQuarterly() {
        removeMetrics()
        for metric in metricsQuarterly {
            let cell = MetricKeyValueView(metric: metric)
            cell.valueLabel.text = balanceSheetsQuarterly.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(balanceSheetsQuarterly.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    private func removeMetrics() {
        for view in content.stockStack.arrangedSubviews where
            (view != titleView && view != subtitleView && view != picker) {
            view.removeFromSuperview()
        }
    }

    func didSelectMetric(_ metric: Metric) {
        let mappedAnual: [PeriodicFinancialModel] = createPeriodicChange(balanceSheet: balanceSheetsAnnual, metric: metric)
        let mappedQuarterly: [PeriodicFinancialModel] = createPeriodicChange(balanceSheet: balanceSheetsQuarterly, metric: metric)

        let vc = PeriodicValueChangeViewController(ticker: balanceSheetsQuarterly.symbol, metricType: metric.text, periodicChangeAnnual: mappedAnual, periodicChangeQuarterly: mappedQuarterly)
        show(vc, sender: self)
    }
    
    func createPeriodicChange(balanceSheet: [BalanceSheet], metric: Metric) -> [PeriodicFinancialModel] {
        var mapped: [PeriodicFinancialModel] = []
        let percentages = balanceSheet.percentageIncrease(metric: metric)
        for (index, financial) in balanceSheet.enumerated() {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.doubleValue, stringValue: mtc.stringValue, percentChange: percentages[index]))
            }
        }
        return mapped
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
