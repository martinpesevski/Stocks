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
    }

    enum Profitability {
        case profitable
        case unprofitable
    }

    static let exchanges = ["New York Stock Exchange", "Nasdaq Global Select", "NYSE"]

    var ticker: Ticker
    var quote: Quote?
    var keyMetricsOverTime: [KeyMetrics]?
    var growthMetrics: [GrowthMetrics]?
    var group = DispatchGroup()
    var intrinsicValue: Float?

    func isValid(filters: [Filter]) -> Bool {
        guard let iv = intrinsicValue, iv > 0 else { return false }
        guard !filters.isEmpty else { return true }
        
        var validCap = !filters.hasMarketCap
        var validProfitability = !filters.hasProfitability

        for filter in filters {
            if let filterCap = filter.marketCap {
                validCap = filterCap == marketCap
            }
            
            if let filterProfitability = filter.profitability {
                validProfitability = filterProfitability == profitability
            }
        }
        
        return validProfitability && validCap
    }

    var discount: Float? {
        guard let intrinsicValue = intrinsicValue else { return nil }
        return (intrinsicValue - ticker.price) / intrinsicValue
    }

    var color: UIColor {
        guard let intrinsicValue = intrinsicValue else { return .red }
        if intrinsicValue * 0.3 > ticker.price { return .green }
        if intrinsicValue > ticker.price { return .systemYellow }
        return .red
    }

    var profitability: Profitability? {
        guard let netIncome = keyMetricsOverTime?[0].netIncomePerShare.floatValue else { return nil }

        return netIncome > 0 ? .profitable : .unprofitable
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
        guard let operatingCashFlow = self.keyMetricsOverTime?[0].operatingCFPerShare.floatValue,
            let rate = growthMetrics?[0].tenYearOCF.floatValue else { return }

        var discountedCashFlow = operatingCashFlow
        var cashFlow = discountedCashFlow
        var discountedCashFlowSum: Float = 0
        let growthRate = rate
        let originalDiscountRate: Float = 0.06
        var discountRate = 1 + originalDiscountRate
        for i in 1...10 {
            let growth = 1 + growthRate
            discountRate = i == 1 ? discountRate : discountRate * (1 + originalDiscountRate)
            cashFlow = (cashFlow * growth)
            discountedCashFlow = cashFlow / discountRate
            discountedCashFlowSum += discountedCashFlow
        }
        
        self.intrinsicValue = discountedCashFlowSum
    }
}
