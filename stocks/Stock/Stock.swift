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

class Stock {
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
        if let profitability = profitability { arr.append(profitability.filter) }
        if let marketCap = marketCap { arr.append(marketCap.filter) }
        return arr
    }

    var profitability: Profitability? {
        guard let keyMetricsOverTime = keyMetricsOverTime?.metrics, !keyMetricsOverTime.isEmpty else { return nil }

        var netIncomeAverage: Float = 0
        for metric in keyMetricsOverTime {
            netIncomeAverage += metric.netIncomePerShare.floatValue ?? 0
        }
        netIncomeAverage /= Float(keyMetricsOverTime.count)

        return netIncomeAverage > 0 ? .profitable : .unprofitable
    }

    var marketCap: MarketCap? {
        guard let marketCap = quote?.profile.mktCap?.floatValue else { return nil }

        if marketCap < 1000000000 { return .small }
        if marketCap < 50000000000 { return .medium }
        return .large
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
