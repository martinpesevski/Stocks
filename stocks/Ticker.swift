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
    var name: String?
    var price: Float
    var exchange: String?

    var isValid: Bool {
        guard let exchange = exchange else { return false }
        return Stock.exchanges.contains(exchange)
    }
}
