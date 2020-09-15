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
    var growthMetrics: [GrowthMetrics]?
    var intrinsicValue: IntrinsicValue?
    var keyMetricsAnnual: [KeyMetrics]?
    var keyMetricsQuarterly: [KeyMetrics]?
    var financialRatiosAnnual: [FinancialRatios]?
    var financialRatiosQuarterly: [FinancialRatios]?
    var balanceSheetsAnnual: [BalanceSheet]?
    var balanceSheetsQuarterly: [BalanceSheet]?
    var incomeStatementsAnnual: [IncomeStatement]?
    var incomeStatementsQuarterly: [IncomeStatement]?
    var cashFlowsAnnual: [CashFlow]?
    var cashFlowsQuarterly: [CashFlow]?

    func isValid(filter: Filter) -> Bool {
        guard let iv = intrinsicValue?.value, iv > 0 else { return false }
        
        return filter.isValid(self.filter)
    }

    var filter: Filter {
        var ftr: Filter = Filter()
        if let profitability = keyMetricsQuarterly?.profitability { ftr.profitabilityFilters = [profitability.filter] }
        ftr.capFilters = [ticker.marketCapType.filter]
        return ftr
    }

    init(ticker: Ticker) {
        self.ticker = ticker
    }
    
    func calculateIntrinsicValue() {
        guard let operatingCashFlow = self.keyMetricsQuarterly?[safe: 0]?.operatingCashFlowPerShare.doubleValue,
            let rate = keyMetricsQuarterly?.projectedFutureGrowth else { return }

        self.intrinsicValue = IntrinsicValue(price: Double(ticker.price), cashFlow: operatingCashFlow, growthRate: rate, discountRate: .low)
    }
    
    func financial(metricType: MetricType) -> (annual: AnyMetric?, quarterly: AnyMetric?) {
        var annual: AnyMetric?
        var quarterly: AnyMetric?
        if let incomeAnnual = incomeStatementsAnnual?.metric(metricType: metricType) { annual = incomeAnnual }
        if let incomeQuarter = incomeStatementsQuarterly?.metric(metricType: metricType) { quarterly = incomeQuarter }
        if let balanceAnnual = balanceSheetsAnnual?.metric(metricType: metricType) { annual = balanceAnnual }
        if let balanceQuarter = balanceSheetsQuarterly?.metric(metricType: metricType) { quarterly = balanceQuarter }
        if let cashFlowAnnual = cashFlowsAnnual?.metric(metricType: metricType) { annual = cashFlowAnnual }
        if let cashFlowQuarter = cashFlowsQuarterly?.metric(metricType: metricType) { quarterly = cashFlowQuarter }
        if let financialRatioAnnual = financialRatiosAnnual?.metric(metricType: metricType) { annual = financialRatioAnnual }
        if let financialRatioQuarter = financialRatiosQuarterly?.metric(metricType: metricType) { quarterly = financialRatioQuarter }
        if let keyMetricAnnual = keyMetricsAnnual?.metric(metricType: metricType) { annual = keyMetricAnnual }
        if let keyMetricQuarter = keyMetricsQuarterly?.metric(metricType: metricType) { quarterly = keyMetricQuarter }
        
        return (annual, quarterly)
    }
}
