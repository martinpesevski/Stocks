//
//  CashFlowViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class CashFlowViewController: StackViewController, MetricKeyValueDelegate {
    let cashFlowsAnnual: [CashFlow]
    let cashFlowsQuarterly: [CashFlow]
    
    let metricsAnnual: [CashFlowFinancialMetric]
    let metricsQuarterly: [CashFlowFinancialMetric]
    
    init(cashFlowsAnnual: [CashFlow], cashFlowsQuarterly: [CashFlow]) {
        self.cashFlowsAnnual = cashFlowsAnnual
        self.cashFlowsQuarterly = cashFlowsQuarterly
        
        self.metricsAnnual = cashFlowsAnnual[safe: 0]?.metrics as? [CashFlowFinancialMetric] ?? []
        self.metricsQuarterly = cashFlowsQuarterly[safe: 0]?.metrics as? [CashFlowFinancialMetric] ?? []
        
        super.init()
        titleView.text = cashFlowsAnnual.symbol
        subtitleView.text = "Cash flow statement"
        
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
            cell.valueLabel.text = cashFlowsAnnual.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(cashFlowsAnnual.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    private func setupQuarterly() {
        removeMetrics()
        for metric in metricsQuarterly {
            let cell = MetricKeyValueView(metric: metric)
            cell.valueLabel.text = cashFlowsQuarterly.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(cashFlowsQuarterly.periodicValues(metric: metric))
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
        let mappedAnual: [PeriodicFinancialModel] = createPeriodicChange(cashFlows: cashFlowsAnnual, metric: metric)
        let mappedQuarterly: [PeriodicFinancialModel] = createPeriodicChange(cashFlows: cashFlowsQuarterly, metric: metric)

        let vc = PeriodicValueChangeViewController(ticker: cashFlowsQuarterly.symbol, metricType: metric.text, periodicChangeAnnual: mappedAnual, periodicChangeQuarterly: mappedQuarterly)
        show(vc, sender: self)
    }
    
    func createPeriodicChange(cashFlows: [CashFlow], metric: Metric) -> [PeriodicFinancialModel] {
        var mapped: [PeriodicFinancialModel] = []
        let percentages = cashFlows.percentageIncrease(metric: metric)
        for (index, financial) in cashFlows.enumerated() {
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
