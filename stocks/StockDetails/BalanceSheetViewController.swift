//
//  BalanceSheetTable.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class BalanceSheetViewController: ViewController, MetricKeyValueDelegate {
    let balanceSheets: BalanceSheetArray
    
    lazy var titleView = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var subtitleView = UILabel(text: "Balance Sheet", font: UIFont.systemFont(ofSize: 17, weight: .bold))
    lazy var content = ScrollableStackView(views: [titleView, subtitleView], spacing: 10)
    
    init(balanceSheets: BalanceSheetArray) {
        self.balanceSheets = balanceSheets
        super.init(nibName: nil, bundle: nil)
        titleView.text = balanceSheets.symbol
        content.setCustomSpacing(25, after: subtitleView)

        guard let metrics = balanceSheets.financials?[safe: 0]?.metrics else { return }

        for metric in metrics {
            let cell = MetricKeyValueView(metric: metric)
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }

    func didSelectMetric(_ metric: Metric) {
        guard let financials = balanceSheets.financials else { return }
        var mapped: [PeriodicFinancialModel] = []
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.value))
            }
        }

        let vc = PeriodicValueChangeViewController(ticker: balanceSheets.symbol, metricType: metric.text, periodicChange: mapped)
        show(vc, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(content)
        content.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
