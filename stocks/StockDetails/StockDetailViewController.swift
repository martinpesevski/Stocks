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

    lazy var nameLabel = UILabel(font: UIFont.systemFont(ofSize: 30, weight: .bold))
    lazy var priceLabel = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var intrinsicValueLabel = UILabel(text: "Intrinsic Value:", font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var intrinsicValueNumber = UILabel(font: UIFont.systemFont(ofSize: 30, weight: .bold))
    lazy var intrinsicValueDiscount = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .right)
    lazy var ivNumberStack = UIStackView(views: [intrinsicValueNumber, intrinsicValueDiscount], axis: .vertical, spacing: 5)
    lazy var ivStack = UIStackView(views: [intrinsicValueLabel, ivNumberStack], axis: .horizontal, spacing: 10)

    lazy var growthTable = GrowthTable()

    lazy var stockStack: ScrollableStackView = {
        let stack = ScrollableStackView(views: [nameLabel, priceLabel, ivStack, growthTable], alignment: .fill, spacing: 10,
        layoutInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        stack.setCustomSpacing(25, after: nameLabel)
        stack.setCustomSpacing(25, after: ivStack)
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stockStack)
        stockStack.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMargins)
        }
    }
    
    init(stock: Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
        
        stock.load { [weak self] in
            guard let self = self else { return }
            self.setup(stock: stock)
        }
    }
    
    func setup(stock: Stock) {
        nameLabel.text = stock.ticker.detailName
        priceLabel.text = String(format: "Current price:     $%.2f", stock.ticker.price)

        if let intrinsicValue = stock.intrinsicValue {
            intrinsicValueNumber.text = String(format: "$%.2f", intrinsicValue.value)
            intrinsicValueNumber.textColor = intrinsicValue.color
            intrinsicValueDiscount.text = String(format: "Discount: %.2f%%", intrinsicValue.discount)
            intrinsicValueDiscount.textColor = intrinsicValue.color
        } else {
            intrinsicValueNumber.text = "N/A"
        }

        growthTable.keyMetrics = stock.keyMetricsOverTime
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
