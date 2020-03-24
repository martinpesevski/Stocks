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
    @IBOutlet var intrinsicValueLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    
    func setup(stock: Stock) {
        tickerLabel.text = stock.ticker.symbol
        tickerName.text = stock.ticker.name
        priceLabel.text = String(format:"%.02f", stock.ticker.price)
        intrinsicValueLabel.textColor = stock.color
        if let iv = stock.intrinsicValue?.value {
            intrinsicValueLabel.text = String(format: "%.02f", iv)
        } else {
            intrinsicValueLabel.text = "N/A"
        }
    }
}
