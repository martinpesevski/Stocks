//
//  StockCell.swift
//  stocks
//
//  Created by Martin Peshevski on 2/22/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {
    @IBOutlet var tickerLabel: UILabel!
    @IBOutlet var tickerName: UILabel!
    
    @IBOutlet var statementsStack: UIStackView!
    
    func setup(stock: Stock) {
        tickerLabel.text = stock.ticker.ticker
        tickerName.text = stock.ticker.name
        
        let cash = stock.balanceSheet?.totalCash
        let liabilities = stock.balanceSheet?.totalLiabilities
        
        if cash != nil && cash != 0{
            print("cash")
        }
//        if let values = stock.balanceSheet?.values {
//            for value in values {
//                let valueLabel = UILabel()
//                valueLabel.textAlignment = .right
//                valueLabel.textColor = .black
//                valueLabel.text = value.standardisedName
//                statementsStack.addArrangedSubview(valueLabel)
//            }
//        }
    }
    
    override func prepareForReuse() {
        for view in statementsStack.arrangedSubviews {
            statementsStack.removeArrangedSubview(view)
        }
    }
}
