//
//  Stock.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol StockDataDelegate: class {
    func didFinishDownloading(_ stock: Stock)
}

enum MarketCap {
    case small
    case medium
    case large

    var filter: Filter {
        switch self {
        case .small: return .smallCap
        case .medium: return .midCap
        case .large: return .largeCap
        }
    }

    var queryStringValue: String {
        switch self {
        case .small: return "marketCapLowerThan=1000000000"
        case .medium: return "marketCapMoreThan=1000000000&marketCapLowerThan=50000000000"
        case .large: return "marketCapMoreThan=50000000000"
        }
    }

    static func fromValue(_ value: Double) -> MarketCap {
        if value < 1000000000 { return .small }
        if value < 50000000000 { return .medium }
        return .large
    }
}

enum Profitability {
    case profitable
    case unprofitable

    var filter: Filter {
        switch self {
        case .profitable: return .profitable
        case .unprofitable: return .unprofitable
        }
    }
}

class Stock {
    static let exchanges = ["New York Stock Exchange", "Nasdaq Global Select", "NYSE"]

    var ticker: Ticker
    var quote: Quote?
    var keyMetricsOverTime: KeyMetricsArray?
    var growthMetrics: [GrowthMetrics]?
    var group = DispatchGroup()
    var intrinsicValue: IntrinsicValue?

    func isValid(filters: [Filter]) -> Bool {
        guard let iv = intrinsicValue?.value, iv > 0 else { return false }
        guard !filters.isEmpty else { return true }

        for filter in self.filters where !filters.contains(filter) {
            if filter.profitability != nil && filters.hasProfitability { return false }
            if filter.marketCap != nil && filters.hasMarketCap { return false }
        }
        return true
    }

    var filters: [Filter] {
        var arr: [Filter] = []
        if let profitability = keyMetricsOverTime?.profitability { arr.append(profitability.filter) }
        if let marketCap = quote?.marketCap { arr.append(marketCap.filter) }
        return arr
    }

    init(ticker: Ticker) {
        self.ticker = ticker
    }
    
    func calculateIntrinsicValue() {
        guard let operatingCashFlow = self.keyMetricsOverTime?.metrics?[0].operatingCFPerShare.floatValue,
            let rate = keyMetricsOverTime?.projectedFutureGrowth else { return }

        self.intrinsicValue = IntrinsicValue(price: ticker.price, cashFlow: operatingCashFlow, growthRate: rate, discountRate: .low)
    }
}
