//
//  Stock.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol StockDataDelegate: AnyObject {
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

    var isLoaded: Bool {
        quote != nil &&
        keyMetricsAnnual != nil &&
        keyMetricsQuarterly != nil &&
        financialRatiosAnnual != nil &&
        financialRatiosQuarterly != nil &&
        balanceSheetsAnnual != nil &&
        balanceSheetsQuarterly != nil &&
        incomeStatementsAnnual != nil &&
        incomeStatementsQuarterly != nil &&
        cashFlowsAnnual != nil &&
        cashFlowsQuarterly != nil
    }
    
    func isValid(filter: Filter) -> Bool {
        var isMetricFilterValid = false
        for metricFilter in filter.metricFilters {
            if let ba = balanceSheetsAnnual, ba.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = ba.filterFivePeriodsBack(metricFilter: metricFilter) }
            if let ia = incomeStatementsAnnual, ia.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = ia.filterFivePeriodsBack(metricFilter: metricFilter) }
            if let cfa = cashFlowsAnnual, cfa.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = cfa.filterFivePeriodsBack(metricFilter: metricFilter) }
            if let kma = keyMetricsAnnual, kma.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = kma.filterFivePeriodsBack(metricFilter: metricFilter) }
            
            if let bq = balanceSheetsQuarterly, bq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = bq.filterFivePeriodsBack(metricFilter: metricFilter) }
            if let iq = incomeStatementsQuarterly, iq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = iq.filterFivePeriodsBack(metricFilter: metricFilter) }
            if let cfq = cashFlowsQuarterly, cfq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = cfq.filterFivePeriodsBack(metricFilter: metricFilter) }
            if let kmq = keyMetricsQuarterly, kmq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = kmq.filterFivePeriodsBack(metricFilter: metricFilter) }
            
            if !isMetricFilterValid {
                if let bsq = balanceSheetsQuarterly, bsq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = bsq.filterPreviousQuarter(metricFilter: metricFilter) }
                if let isq = incomeStatementsQuarterly, isq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = isq.filterPreviousQuarter(metricFilter: metricFilter) }
                if let cfq = cashFlowsQuarterly, cfq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = cfq.filterPreviousQuarter(metricFilter: metricFilter) }
                if let kmq = keyMetricsQuarterly, kmq.isEligibleForFilter(metricFilter: metricFilter) { isMetricFilterValid = kmq.filterPreviousQuarter(metricFilter: metricFilter) } 
            }
            if !isMetricFilterValid { break }
        }
        
        return filter.isValid(self.filter) && isMetricFilterValid
    }

    lazy var filter: Filter = {
        var ftr: Filter = Filter()
        if let profitability = keyMetricsQuarterly?.profitability { ftr.profitabilityFilters = [profitability.filter] }
        ftr.capFilters = [ticker.marketCapType.filter]
        if let sector = quote?.sector { ftr.sectorFilters = [sector] }
        
        return ftr
    }()

    init(ticker: Ticker) {
        self.ticker = ticker
    }
    
    func calculateIntrinsicValue() {
        guard let operatingCashFlow = self.keyMetricsQuarterly?[safe: 0]?.operatingCashFlowPerShare?.doubleValue,
            let rate = keyMetricsQuarterly?.projectedFutureGrowth else { return }

        self.intrinsicValue = IntrinsicValue(price: Double(ticker.price), cashFlow: operatingCashFlow, growthRate: rate, discountRate: .low)
    }
    
    func metric(metricType: MetricType) -> (annual: AnyMetric?, quarterly: AnyMetric?) {
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
