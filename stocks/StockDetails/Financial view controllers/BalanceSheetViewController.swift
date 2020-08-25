//
//  BalanceSheetTable.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class BalanceSheetViewController: StackViewController, MetricKeyValueDelegate {
    let balanceSheetsAnnual: BalanceSheetArray
    let balanceSheetsQuarterly: BalanceSheetArray

    let metricsAnnual: [BalanceSheetFinancialMetric]
    let metricsQuarterly: [BalanceSheetFinancialMetric]
    
    lazy var picker: UISegmentedControl = {
        let items = ["Annual", "Quarterly"]
        let v = UISegmentedControl(items: items)
        v.selectedSegmentIndex = 0
        v.layer.cornerRadius = 5.0
        v.backgroundColor = .systemGray6
        v.tintColor = .systemGray5
        v.selectedSegmentTintColor = .systemGreen

        v.addTarget(self, action: #selector(onPeriodChanged(sender:)), for: .valueChanged)
        
        return v
    }()
    
    init(balanceSheetsAnnual: BalanceSheetArray, balanceSheetsQuarterly: BalanceSheetArray) {
        self.balanceSheetsAnnual = balanceSheetsAnnual
        self.balanceSheetsQuarterly = balanceSheetsQuarterly
        
        self.metricsAnnual = balanceSheetsAnnual.financials?[safe: 0]?.metrics ?? []
        self.metricsQuarterly = balanceSheetsQuarterly.financials?[safe: 0]?.metrics ?? []
        
        super.init()
        titleView.text = balanceSheetsAnnual.symbol
        subtitleView.text = "Balance sheet"
        
        content.addArrangedSubview(picker)
        content.setCustomSpacing(25, after: picker)

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
            cell.chart.setData(balanceSheetsAnnual.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    private func setupQuarterly() {
        removeMetrics()
        for metric in metricsQuarterly {
            let cell = MetricKeyValueView(metric: metric)
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
        guard let financials = balanceSheetsAnnual.financials else { return }
        var mapped: [PeriodicFinancialModel] = []
        let percentages = balanceSheetsAnnual.percentageIncrease(metric: metric)
        for (index, financial) in financials.enumerated() {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.value, percentChange: percentages[index]))
            }
        }

        let vc = PeriodicValueChangeViewController(ticker: balanceSheetsAnnual.symbol, metricType: metric.text, periodicChange: mapped)
        show(vc, sender: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
