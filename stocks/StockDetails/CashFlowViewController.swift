//
//  CashFlowViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class CashFlowViewController: ViewController {
    let cashFlows: CashFlowsArray

    lazy var titleView = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var subtitleView = UILabel(text: "Cash flow statement", font: UIFont.systemFont(ofSize: 17, weight: .bold))
    lazy var content = ScrollableStackView(views: [titleView, subtitleView], spacing: 10)

    init(cashFlows: CashFlowsArray) {
        self.cashFlows = cashFlows
        super.init(nibName: nil, bundle: nil)
        titleView.text = cashFlows.symbol
        content.setCustomSpacing(25, after: subtitleView)

        guard let metrics = cashFlows.financials?[safe: 0]?.metrics else { return }

        for metric in metrics {
            guard let key = metric.metricType?.text else { return }
            let cell = KeyValueView(key: key, value: "\(metric.value)")
            content.addArrangedSubview(cell)
        }
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
