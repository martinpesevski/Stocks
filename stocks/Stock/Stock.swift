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

    var filter: CapFilter {
        switch self {
        case .small: return .smallCap
        case .medium: return .midCap
        case .large: return .largeCap
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

    var filter: ProfitabilityFilter {
        switch self {
        case .profitable: return .profitable
        case .unprofitable: return .unprofitable
        }
    }
}

class Stock {
    var ticker: Ticker
    var quote: Quote?
    var keyMetricsOverTime: KeyMetricsArray?
    var growthMetrics: [GrowthMetrics]?
    var intrinsicValue: IntrinsicValue?
    var financialRatiosAnnual: [FinancialRatios]?
    var financialRatiosQuarterly: [FinancialRatios]?
    var balanceSheetsAnnual: BalanceSheetArray?
    var balanceSheetsQuarterly: BalanceSheetArray?
    var incomeStatementsAnnual: [IncomeStatement]?
    var incomeStatementsQuarterly: [IncomeStatement]?
    var cashFlowsAnnual: CashFlowsArray?
    var cashFlowsQuarterly: CashFlowsArray?

    func isValid(filter: Filter) -> Bool {
        guard let iv = intrinsicValue?.value, iv > 0 else { return false }
        
        return filter.isValid(self.filter)
    }

    var filter: Filter {
        var ftr: Filter = Filter()
        if let profitability = keyMetricsOverTime?.profitability { ftr.profitabilityFilters = [profitability.filter] }
        ftr.capFilters = [ticker.marketCapType.filter]
        return ftr
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
