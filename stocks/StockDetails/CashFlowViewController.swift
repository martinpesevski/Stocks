//
//  CashFlowViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class CashFlowViewController: StackViewController, MetricKeyValueDelegate {
    let cashFlows: CashFlowsArray

    init(cashFlows: CashFlowsArray) {
        self.cashFlows = cashFlows
        super.init()
        titleView.text = cashFlows.symbol
        subtitleView.text = "Cash flow statement"

        guard let metrics = cashFlows.financials?[safe: 0]?.metrics else { return }

        for metric in metrics {
            let cell = MetricKeyValueView(metric: metric)
            cell.chart.setData(cashFlows.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }

    func didSelectMetric(_ metric: Metric) {
        guard let financials = cashFlows.financials else { return }
        var mapped: [PeriodicFinancialModel] = []
        let percentages = cashFlows.percentageIncrease(metric: metric)
        for financial in financials {
            for (index, mtc) in financial.metrics.enumerated() where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.value, percentChange: percentages[index]))
            }
        }

        let vc = PeriodicValueChangeViewController(ticker: cashFlows.symbol, metricType: metric.text, periodicChange: mapped)
        show(vc, sender: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
