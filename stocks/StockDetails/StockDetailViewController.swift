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
    lazy var financialratios = AccessoryView("Financial ratios", accessoryType: .rightArrow)
    lazy var intrinsicValue = AccessoryView("Intrinsic Value", accessoryType: .rightArrow)

    lazy var growthTable = GrowthTable()
    lazy var header = StockInfoHeader()
    lazy var preferredMetrics = PreferredMetricsTable(stock: stock, items: nil)

    lazy var stockStack: ScrollableStackView = {
        let stack = ScrollableStackView(views: [header, financials, financialratios, intrinsicValue, preferredMetrics], alignment: .fill, spacing: 10,
        layoutInsets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
        stack.setCustomSpacing(25, after: header)
        stack.setCustomSpacing(25, after: intrinsicValue)
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.startLoading()
        stock.load { [weak self] in
            guard let self = self else { return }
            
            self.view.finishLoading()
            self.view.addSubview(self.stockStack)
            self.stockStack.snp.makeConstraints { make in
                make.edges.equalTo(self.view.layoutMargins)
            }
            self.setup(stock: self.stock)
        }
        
        financials.button.addTarget(self, action: #selector(onFinancials), for: .touchUpInside)
        financialratios.button.addTarget(self, action: #selector(onFinancialRatios), for: .touchUpInside)
        intrinsicValue.button.addTarget(self, action: #selector(onIntrinsicValue), for: .touchUpInside)
    }
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    func setup(stock: Stock) {
        header.setup(stock: stock)
        growthTable.keyMetrics = stock.keyMetricsQuarterly
    }
    
    @objc func onFinancials() {
        let vc = FinancialsViewController(stock: stock)
        show(vc, sender: self)
    }
    
    @objc func onFinancialRatios() {
        guard let annual = stock.financialRatiosAnnual, let quarterly = stock.financialRatiosQuarterly else { return }
        let vc = MetricViewController(annualFinancial: annual.map { AnyFinancial($0) }, quarterlyFinancial: quarterly.map { AnyFinancial($0) }, title: "Financial ratios")
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
