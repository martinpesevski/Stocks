//
//  StockDetailHelpers.swift
//  stocks
//
//  Created by Martin Peshevski on 4/15/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class StackViewController: ViewController {
    lazy var titleView = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var subtitleView = UILabel(font: UIFont.systemFont(ofSize: 17, weight: .bold))
    lazy var content = ScrollableStackView(views: [titleView, subtitleView], spacing: 10, layoutInsets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))

    init() {
        super.init(nibName: nil, bundle: nil)
        content.setCustomSpacing(25, after: subtitleView)
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
