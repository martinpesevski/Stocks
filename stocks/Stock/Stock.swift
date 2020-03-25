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
    var intrinsicValue: IntrinsicValue?

    func isValid(filters: [Filter]) -> Bool {
        guard let iv = intrinsicValue?.value, iv > 0 else { return false }
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
        guard let intrinsicValue = intrinsicValue?.value else { return nil }
        return (intrinsicValue - ticker.price) / intrinsicValue
    }

    var color: UIColor {
        guard let intrinsicValue = intrinsicValue?.value else { return .red }
        if intrinsicValue * 0.3 > ticker.price { return .green }
        if intrinsicValue > ticker.price { return .systemYellow }
        return .red
    }

    var profitability: Profitability? {
        guard let keyMetricsOverTime = keyMetricsOverTime, !keyMetricsOverTime.isEmpty else { return nil }

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
        guard let operatingCashFlow = self.keyMetricsOverTime?[0].operatingCFPerShare.floatValue,
            let rate = growthMetrics?[0].fiveYearOCF.floatValue else { return }
        let growthRate = min(rate, 0.15)
        
        self.intrinsicValue = IntrinsicValue(cashFlow: operatingCashFlow, growthRate: growthRate, discountRate: .low)
    }
}

struct IntrinsicValue {
    enum DiscountRate: Float {
        case low = 0.06
        case medium = 0.075
        case high = 0.09
    }

    var discountRates: [Float] = []
    var discountedCashFlows: [Float] = []
    var regularCashFlows: [Float] = []
    var growthRate: Float = 0
    var value: Float = 0

    init(cashFlow ocf: Float, growthRate: Float, discountRate: DiscountRate) {
        discountRates = calculateDiscountRates(discountRate)
        regularCashFlows = calculateFutureCashFlows(cashFlow: ocf, growth: growthRate)
        discountedCashFlows = calculateDiscountedCashFlows(cashFlows: regularCashFlows, discountRates: discountRates)
        self.growthRate = growthRate

        value = discountedCashFlows.reduce(0, +)
    }

    func calculateDiscountRates(_ originalDiscountRate: DiscountRate) -> [Float] {
        var discountRate = 1 + originalDiscountRate.rawValue
        var rates: [Float] = []
        for i in 1...10 {
            discountRate = i == 1 ? discountRate : discountRate * (1 + originalDiscountRate.rawValue)
            rates.append(discountRate)
        }

        return rates
    }

    func calculateFutureCashFlows(cashFlow: Float, growth: Float) -> [Float] {
        var cashFlows: [Float] = []
        for i in 0..<10 {
            let previousCashFlow = cashFlows.isEmpty ? cashFlow : cashFlows[i-1]
            cashFlows.append(previousCashFlow * (1 + growth))
        }
        return cashFlows
    }

    func calculateDiscountedCashFlows(cashFlows: [Float], discountRates: [Float]) -> [Float] {
        var discountedCashFlows: [Float] = []
        for i in 0..<10 {
            let cashFlow = cashFlows[i] / discountRates[i]
            discountedCashFlows.append(cashFlow)
        }
        return discountedCashFlows
    }
}
