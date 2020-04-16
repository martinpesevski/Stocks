//
//  IncomeStatementViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class IncomeStatementViewController: StackViewController, MetricKeyValueDelegate {
    let incomeStatements: IncomeStatementsArray

    init(incomeStatements: IncomeStatementsArray) {
        self.incomeStatements = incomeStatements
        super.init()
        titleView.text = incomeStatements.symbol
        subtitleView.text = "Income statement"

        guard let metrics = incomeStatements.financials?[safe: 0]?.metrics else { return }
        
        for metric in metrics {
            let cell = MetricKeyValueView(metric: metric)
            cell.chart.setData(incomeStatements.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }

    func didSelectMetric(_ metric: Metric) {
        guard let financials = incomeStatements.financials else { return }
        var mapped: [PeriodicFinancialModel] = []
        let percentages = incomeStatements.percentageIncrease(metric: metric)
        for (index, financial) in financials.enumerated() {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.value, percentChange: percentages[index]))
            }
        }

        let vc = PeriodicValueChangeViewController(ticker: incomeStatements.symbol, metricType: metric.text, periodicChange: mapped)
        show(vc, sender: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
