//
//  BalanceSheetTable.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class BalanceSheetViewController: ViewController {
    let balanceSheet: BalanceSheet
    
    lazy var titleView = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var subtitleView = UILabel(text: "Balance Sheet", font: UIFont.systemFont(ofSize: 17, weight: .bold))
    lazy var content = ScrollableStackView(views: [titleView, subtitleView], spacing: 10)
    
    init(balanceSheet: BalanceSheet) {
        self.balanceSheet = balanceSheet
        super.init(nibName: nil, bundle: nil)
        titleView.text = balanceSheet.symbol
        content.setCustomSpacing(25, after: subtitleView)
        
        for metric in balanceSheet.metrics {
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
