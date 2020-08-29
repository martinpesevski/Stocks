//
//  FinancialRatiosViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 8/29/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class FinancialRatiosViewController: StackViewController, MetricKeyValueDelegate {
    let financialRatiosAnnual: [FinancialRatios]
    let financialRatiosQuarterly: [FinancialRatios]

    let metricsAnnual: [FinancialRatioFinancialMetric]
    let metricsQuarterly: [FinancialRatioFinancialMetric]
    
    init(financialRatiosAnnual: [FinancialRatios], financialRatiosQuarterly: [FinancialRatios]) {
        self.financialRatiosAnnual = financialRatiosAnnual
        self.financialRatiosQuarterly = financialRatiosQuarterly
        
        self.metricsAnnual = financialRatiosAnnual[safe: 0]?.metrics ?? []
        self.metricsQuarterly = financialRatiosQuarterly[safe: 0]?.metrics ?? []
        
        super.init()
        titleView.text = financialRatiosAnnual.symbol
        subtitleView.text = "Financial ratios"
        
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
            cell.valueLabel.text = financialRatiosAnnual.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(financialRatiosAnnual.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    private func setupQuarterly() {
        removeMetrics()
        for metric in metricsQuarterly {
            let cell = MetricKeyValueView(metric: metric)
            cell.valueLabel.text = financialRatiosQuarterly.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(financialRatiosQuarterly.periodicValues(metric: metric))
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
        var mapped: [PeriodicFinancialModel] = []
        let percentages = (isAnnual ? financialRatiosAnnual : financialRatiosQuarterly).percentageIncrease(metric: metric)
        for (index, financial) in (isAnnual ? financialRatiosAnnual : financialRatiosQuarterly).enumerated() {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.value, percentChange: percentages[index]))
            }
        }

        let vc = PeriodicValueChangeViewController(ticker: (isAnnual ? financialRatiosAnnual : financialRatiosQuarterly).symbol, metricType: metric.text, periodicChange: mapped)
        show(vc, sender: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
