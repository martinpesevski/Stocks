//
//  StockDetailsViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/25/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class StockDetailViewController: ViewController, PreferredMetricsDelegate, UINavigationControllerDelegate {
    var stock: Stock {
        didSet {
            stock.load { [weak self] in
                guard let self = self else { return }
                self.setup(stock: self.stock)
            }
        }
    }

    lazy var financials = AccessoryView("Financials", accessoryType: .rightArrow)
    lazy var financialMetrics = AccessoryView("Financial metrics", accessoryType: .rightArrow)
    lazy var intrinsicValue = AccessoryView("Intrinsic Value", accessoryType: .rightArrow)

    lazy var growthTable = GrowthTable()
    lazy var header = StockInfoHeader()
    lazy var preferredMetrics = PreferredMetricsTable(stock: stock)
    var isLoading = true

    lazy var stockStack: ScrollableStackView = {
        let stack = ScrollableStackView(views: [header, financials, financialMetrics, preferredMetrics], alignment: .fill, spacing: 10,
        layoutInsets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
        stack.setCustomSpacing(25, after: header)
        stack.setCustomSpacing(25, after: financialMetrics)
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.startLoading()
        stock.load { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            self.view.finishLoading()
            self.view.addSubview(self.stockStack)
            self.stockStack.snp.makeConstraints { make in
                make.edges.equalTo(self.view.layoutMargins)
            }
            self.setup(stock: self.stock)
        }
        
        financials.button.addTarget(self, action: #selector(onFinancials), for: .touchUpInside)
        financialMetrics.button.addTarget(self, action: #selector(onFinancialMetrics), for: .touchUpInside)
        intrinsicValue.button.addTarget(self, action: #selector(onIntrinsicValue), for: .touchUpInside)
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    func setup(stock: Stock) {
        header.setup(stock: stock)
        growthTable.keyMetrics = stock.keyMetricsQuarterly
        preferredMetrics.delegate = self
    }
    
    @objc func onFinancials() {
        let vc = FinancialsViewController(stock: stock)
        show(vc, sender: self)
    }
    
    @objc func onFinancialMetrics() {
        let vc = FinancialMetricsViewController(stock: stock)
        show(vc, sender: self)
    }
    
    @objc func onIntrinsicValue() {
        let vc = IntrinsicValueViewController(stock: stock)
        show(vc, sender: self)
    }
    
    func shouldShow(viewController: UIViewController) {
        show(viewController, sender: self)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            if !self.isLoading { preferredMetrics.update() }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
