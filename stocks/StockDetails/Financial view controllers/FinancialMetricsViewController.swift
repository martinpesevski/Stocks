//
//  FinancialMetricsViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 9/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class FinancialMetricsViewController: ViewController {
    let stock: Stock
    lazy var titleLabel = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var descriptionLabel = UILabel(text: "What would you like to see?", font: UIFont.systemFont(ofSize: 17, weight: .bold))

    lazy var keyMetrics = AccessoryView("Key metrics", accessoryType: .rightArrow)
    lazy var financialRatios = AccessoryView("Financial ratios", accessoryType: .rightArrow)
    
    lazy var content = ScrollableStackView(views: [titleLabel, descriptionLabel, keyMetrics, financialRatios], spacing: 10, layoutInsets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = "\(stock.ticker.symbol) financial metrics"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content.setCustomSpacing(30, after: descriptionLabel)
        
        keyMetrics.button.addTarget(self, action: #selector(onkeyMetrics), for: .touchUpInside)
        financialRatios.button.addTarget(self, action: #selector(onfinancialRatios), for: .touchUpInside)

        view.addSubview(content)
        content.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide) }
    }
    
    @objc func onkeyMetrics() {
        guard let keyMetricsAnnual = stock.keyMetricsAnnual,
            let keyMetricsQuarterly = stock.keyMetricsQuarterly else { return }
        let vc = MetricViewController(annualFinancial: keyMetricsAnnual.map { AnyFinancial($0) },
                                      quarterlyFinancial: keyMetricsQuarterly.map { AnyFinancial($0) },
                                      title: "Key metrics")
        show(vc, sender: self)
    }
    
    @objc func onfinancialRatios() {
        guard let financialRatiosAnnual = stock.financialRatiosAnnual,
            let financialRatiosquarterly = stock.financialRatiosQuarterly
            else { return }
        let vc = MetricViewController(annualFinancial: financialRatiosAnnual.map { AnyFinancial($0) },
                                      quarterlyFinancial: financialRatiosquarterly.map { AnyFinancial($0) },
                                      title: "Financial ratios")
        show(vc, sender: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
