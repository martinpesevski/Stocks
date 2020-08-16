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
        guard let incomeStatements = stock.incomeStatements else { return }
        let vc = IncomeStatementViewController(incomeStatements: incomeStatements)
        show(vc, sender: self)
    }
    
    @objc func onBalanceSheet() {
        guard let balanceSheets = stock.balanceSheets else { return }
        let vc = BalanceSheetViewController(balanceSheets: balanceSheets)
        show(vc, sender: self)
    }
    
    @objc func onCashFlow() {
        guard let cashFlows = stock.cashFlows else { return }
        let vc = CashFlowViewController(cashFlows: cashFlows)
        show(vc, sender: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
