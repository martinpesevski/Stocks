//
//  PeriodicValueChangeViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

struct PeriodicFinancialModel {
    var period: String
    var value: String
}

class PeriodicValueChangeViewController: ViewController {
    lazy var titleView = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var subtitleView = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .bold))
    lazy var content = ScrollableStackView(views: [titleView, subtitleView], spacing: 10)

    init(ticker: String, metricType: String, periodicChange: [PeriodicFinancialModel]) {
        super.init(nibName: nil, bundle: nil)
        titleView.text = ticker
        subtitleView.text = metricType
        content.setCustomSpacing(25, after: subtitleView)

        for metric in periodicChange {
            let cell = KeyValueView(key: metric.period, value: metric.value)
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
