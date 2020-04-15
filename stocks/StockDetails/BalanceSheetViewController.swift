//
//  BalanceSheetTable.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class BalanceSheetViewController: StackViewController, MetricKeyValueDelegate {
    let balanceSheets: BalanceSheetArray
    
    init(balanceSheets: BalanceSheetArray) {
        self.balanceSheets = balanceSheets
        super.init()
        titleView.text = balanceSheets.symbol
        subtitleView.text = "Balance sheet"

        guard let metrics = balanceSheets.financials?[safe: 0]?.metrics else { return }

        for metric in metrics {
            let cell = MetricKeyValueView(metric: metric)
            cell.chart.setData(balanceSheets.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }

    func didSelectMetric(_ metric: Metric) {
        guard let financials = balanceSheets.financials else { return }
        var mapped: [PeriodicFinancialModel] = []
        let periodicValues = balanceSheets.periodicValues(metric: metric)
        for financial in financials {
            for (index, mtc) in financial.metrics.enumerated() where mtc.metricType?.text == metric.text {
                let percentage = ((periodicValues[index] - (periodicValues[safe: index - 1] ?? 0)) / periodicValues[index]) * 100
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.value, percentChange: percentage))
            }
        }

        let vc = PeriodicValueChangeViewController(ticker: balanceSheets.symbol, metricType: metric.text, periodicChange: mapped)
        show(vc, sender: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
