//
//  IncomeStatementViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol MetricKeyValueDelegate: class {
    func didSelectMetric(_ metric: Metric)
}

class MetricKeyValueView: KeyValueView {
    weak var delegate: MetricKeyValueDelegate?
    let metric: Metric
    lazy var chart = SimpleGrowthChart()

    init(metric: Metric) {
        self.metric = metric
        super.init(key: metric.text, value: metric.value)
        valueLabel.removeFromSuperview()
        addArrangedSubview(chart)
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }

    @objc func onTap() {
        delegate?.didSelectMetric(metric)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IncomeStatementViewController: ViewController, MetricKeyValueDelegate {
    let incomeStatements: IncomeStatementsArray
    
    lazy var titleView = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var subtitleView = UILabel(text: "Income Statement", font: UIFont.systemFont(ofSize: 17, weight: .bold))
    lazy var content = ScrollableStackView(views: [titleView, subtitleView], spacing: 10)
    
    init(incomeStatements: IncomeStatementsArray) {
        self.incomeStatements = incomeStatements
        super.init(nibName: nil, bundle: nil)
        titleView.text = incomeStatements.symbol
        content.setCustomSpacing(25, after: subtitleView)
        
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
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.value))
            }
        }

        let vc = PeriodicValueChangeViewController(ticker: incomeStatements.symbol, metricType: metric.text, periodicChange: mapped)
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
