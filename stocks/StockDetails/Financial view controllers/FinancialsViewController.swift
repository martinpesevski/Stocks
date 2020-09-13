//
//  FinancialsViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class FinancialsViewController: ViewController {
    let stock: Stock
    lazy var titleLabel = UILabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
    lazy var descriptionLabel = UILabel(text: "Which statement would you like to see?", font: UIFont.systemFont(ofSize: 17, weight: .bold))

    lazy var incomeStatement = AccessoryView("Income statement", accessoryType: .rightArrow)
    lazy var balanceSheet = AccessoryView("Balance sheet", accessoryType: .rightArrow)
    lazy var cashFlow = AccessoryView("Cash flow", accessoryType: .rightArrow)
    
    lazy var content = ScrollableStackView(views: [titleLabel, descriptionLabel, incomeStatement, balanceSheet, cashFlow], spacing: 10, layoutInsets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = "\(stock.ticker.symbol) financial statements"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content.setCustomSpacing(30, after: descriptionLabel)
        
        incomeStatement.button.addTarget(self, action: #selector(onIncomeStatement), for: .touchUpInside)
        balanceSheet.button.addTarget(self, action: #selector(onBalanceSheet), for: .touchUpInside)
        cashFlow.button.addTarget(self, action: #selector(onCashFlow), for: .touchUpInside)

        view.addSubview(content)
        content.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide) }
    }
    
    @objc func onIncomeStatement() {
        guard let incomeStatementsAnnual = stock.incomeStatementsAnnual,
            let incomeStatementsQuarterly = stock.incomeStatementsQuarterly else { return }
        let vc = MetricViewController(annualFinancial: incomeStatementsAnnual.map { AnyFinancial($0) },
                                      quarterlyFinancial: incomeStatementsQuarterly.map { AnyFinancial($0) },
                                      title: "Income statement")
        show(vc, sender: self)
    }
    
    @objc func onBalanceSheet() {
        guard let balanceSheetsAnnual = stock.balanceSheetsAnnual,
            let balanceSheetsQuarterly = stock.balanceSheetsQuarterly
            else { return }
        let vc = MetricViewController(annualFinancial: balanceSheetsAnnual.map { AnyFinancial($0) },
                                      quarterlyFinancial: balanceSheetsQuarterly.map { AnyFinancial($0) },
                                      title: "Balance sheet")
        show(vc, sender: self)
    }
    
    @objc func onCashFlow() {
        guard let cashFlowsAnnual = stock.cashFlowsAnnual,
            let cashFlowsQuarterly = stock.cashFlowsQuarterly else { return }
        let vc = MetricViewController(annualFinancial: cashFlowsAnnual.map { AnyFinancial($0) },
                                      quarterlyFinancial: cashFlowsQuarterly.map { AnyFinancial($0) },
                                      title: "Cash flow")
        show(vc, sender: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
