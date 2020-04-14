//
//  IncomeStatementViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class IncomeStatementViewController: ViewController {
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
