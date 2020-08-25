//
//  StockInfoHeader.swift
//  Stocker
//
//  Created by Martin Peshevski on 8/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class StockInfoHeader: UIStackView {
    lazy var nameLabel = UILabel(font: UIFont.systemFont(ofSize: 30, weight: .bold))
    lazy var priceLabel = UILabel(text: "Current price:", font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var priceNumberLabel : UILabel = {
        let lbl = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold), alignment: .right)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 1
        return lbl
    }()
    lazy var intrinsicValueLabel = UILabel(text: "Intrinsic Value:", font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var intrinsicValueNumber: UILabel = {
        let lbl = UILabel(font: UIFont.systemFont(ofSize: 30, weight: .bold), alignment: .right)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 1
        return lbl
    }()

    lazy var priceStack = UIStackView(views: [priceLabel, priceNumberLabel], axis: .horizontal, spacing: 10)
    lazy var intrinsicValueDiscount = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .right)
    lazy var ivNumberStack = UIStackView(views: [intrinsicValueNumber, intrinsicValueDiscount], axis: .vertical, spacing: 5)
    lazy var ivStack = UIStackView(views: [intrinsicValueLabel, ivNumberStack], axis: .horizontal, spacing: 10)
    
    init() {
        super.init(frame: .zero)
        addArrangedSubview(nameLabel)
        addArrangedSubview(priceStack)
        addArrangedSubview(ivStack)
        axis = .vertical
        spacing = 10
        setCustomSpacing(25, after: nameLabel)
    }
    
    func setup(stock: Stock) {
        nameLabel.text = stock.ticker.detailName
        priceNumberLabel.text = String(format: "$%.2f", stock.ticker.price)


        if let intrinsicValue = stock.intrinsicValue {
            intrinsicValueNumber.text = String(format: "$%.2f", intrinsicValue.value)
            intrinsicValueNumber.textColor = intrinsicValue.color
            intrinsicValueDiscount.text = String(format: "Discount: %.2f%%", intrinsicValue.discount)
            intrinsicValueDiscount.textColor = intrinsicValue.color
        } else {
            intrinsicValueNumber.text = "N/A"
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
