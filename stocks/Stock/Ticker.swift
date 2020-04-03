//
//  Ticker.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct TickerArray: Codable {
    var symbolsList: [Ticker]
}
struct Ticker: Codable {
    var symbol: String
    var companyName: String?
    var marketCap: Float
    var sector: String
    var beta: Float
    var price: Float
    var volume: Float

//    var isValid: Bool {
//        guard let exchange = exchange else { return false }
//        return Stock.exchanges.contains(exchange)
//    }

    var detailName: String {
        if let name = companyName {
            return "\(name) (\(symbol))"
        } else {
            return symbol
        }
    }
}

struct Screener: Codable {
    var symbol: String
    var companyName: String
    var marketCap: String
    var sector: String
    var beta: String
    var price: String
    var volume: String
}
