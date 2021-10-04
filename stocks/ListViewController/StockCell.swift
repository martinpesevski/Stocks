//
//  StockCell.swift
//  stocks
//
//  Created by Martin Peshevski on 2/22/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {
    lazy var tickerLabel = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var tickerName = UILabel(font: UIFont.systemFont(ofSize: 15))
    
    lazy var tickerStack = UIStackView(views: [tickerLabel, tickerName], axis: .vertical, alignment: .leading, spacing: 5)
    lazy var priceLabel = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var numbersStack = UIStackView(views: [priceLabel], axis: .vertical, alignment: .trailing, spacing: 5)

    lazy var contentStack = UIStackView(views: [tickerStack, numbersStack], axis: .horizontal,
                                   distribution: .fillEqually,
                                   alignment: .fill,
                                   spacing: 5,
                                   layoutInsets: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    lazy var content: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGray6
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        selectionStyle = .none
        content.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in make.edges.equalToSuperview() }
        
        addSubview(content)
        content.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setup(stock: Stock) {
        tickerLabel.text = stock.ticker.symbol
        tickerName.text = stock.ticker.companyName
        priceLabel.text = String(format: "%.02f", stock.ticker.price)

//        if let iv = stock.intrinsicValue {
//            priceLabel.text = String(format: "%.02f", stock.ticker.price)
//            priceLabel.textColor = iv.color
//        } else {
//            priceLabel.text = "N/A"
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
