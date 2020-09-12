//
//  IncomeStatementViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class IncomeStatementViewController: StackViewController, MetricKeyValueDelegate {
    let incomeStatementsAnnual: [IncomeStatement]
    let incomeStatementsQuarterly: [IncomeStatement]

    let metricsAnnual: [IncomeStatementFinancialMetric]
    let metricsQuarterly: [IncomeStatementFinancialMetric]
    
    init(incomeStatementsAnnual: [IncomeStatement], incomeStatementsQuarterly: [IncomeStatement]) {
        self.incomeStatementsAnnual = incomeStatementsAnnual
        self.incomeStatementsQuarterly = incomeStatementsQuarterly
        
        self.metricsAnnual = incomeStatementsAnnual[safe: 0]?.metrics ?? []
        self.metricsQuarterly = incomeStatementsQuarterly[safe: 0]?.metrics ?? []
        
        super.init()
        titleView.text = incomeStatementsAnnual.symbol
        subtitleView.text = "Income statement"

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
            cell.valueLabel.text = incomeStatementsAnnual.latestValue(metric: metric)
            cell.chart.setData(incomeStatementsAnnual.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    private func setupQuarterly() {
        removeMetrics()
        for metric in metricsQuarterly {
            let cell = MetricKeyValueView(metric: metric)
            cell.valueLabel.text = incomeStatementsQuarterly.latestValue(metric: metric)
            cell.chart.setData(incomeStatementsQuarterly.periodicValues(metric: metric))
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
        let mappedAnual: [PeriodicFinancialModel] = createPeriodicChange(incomeStatements: incomeStatementsAnnual, metric: metric)
        let mappedQuarterly: [PeriodicFinancialModel] = createPeriodicChange(incomeStatements: incomeStatementsQuarterly, metric: metric)

        let vc = PeriodicValueChangeViewController(ticker: incomeStatementsQuarterly.symbol, metricType: metric.text, periodicChangeAnnual: mappedAnual, periodicChangeQuarterly: mappedQuarterly)
        show(vc, sender: self)
    }
    
    func createPeriodicChange(incomeStatements: [IncomeStatement], metric: Metric) -> [PeriodicFinancialModel] {
        var mapped: [PeriodicFinancialModel] = []
        let percentages = incomeStatements.percentageIncrease(metric: metric)
        for (index, financial) in incomeStatements.enumerated() {
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
