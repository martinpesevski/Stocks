//
//  StockDetailsViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/25/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class StockDetailViewController: ViewController {
    var stock: Stock {
        didSet {
            stock.load { [weak self] in
                guard let self = self else { return }
                self.setup(stock: self.stock)
            }
        }
    }

    lazy var financials = AccessoryView("Financials", accessoryType: .rightArrow)
    lazy var growth = AccessoryView("Growth", accessoryType: .rightArrow)
    lazy var intrinsicValue = AccessoryView("Intrinsic Value", accessoryType: .rightArrow)

    lazy var growthTable = GrowthTable()
    lazy var header = StockInfoHeader()
    
    lazy var stockStack: ScrollableStackView = {
        let stack = ScrollableStackView(views: [header, financials, growth, intrinsicValue], alignment: .fill, spacing: 10,
        layoutInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        stack.setCustomSpacing(25, after: header)
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stockStack)
        stockStack.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMargins)
        }
        
        stock.load { [weak self] in
            guard let self = self else { return }
            self.setup(stock: self.stock)
        }
        
        financials.button.addTarget(self, action: #selector(onFinancials), for: .touchUpInside)
        intrinsicValue.button.addTarget(self, action: #selector(onIntrinsicValue), for: .touchUpInside)
    }
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    func setup(stock: Stock) {
        header.setup(stock: stock)
        growthTable.keyMetrics = stock.keyMetricsOverTime
    }
    
    @objc func onFinancials() {
        let vc = FinancialsViewController(stock: stock)
        show(vc, sender: self)
    }
    
    @objc func onIntrinsicValue() {
        let vc = IntrinsicValueViewController(stock: stock)
        show(vc, sender: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
