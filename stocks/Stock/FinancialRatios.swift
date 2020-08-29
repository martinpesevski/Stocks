//
//  FinancialRatios.swift
//  Stocker
//
//  Created by Martin Peshevski on 8/28/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct FinancialRatioFinancialMetric: Codable, Metric {
    let value: String
    var metricType: FinancialRatioMetricType?

    var text: String { metricType?.text ?? "" }

    init(from decoder: Decoder) throws {
        value = "\(try decoder.singleValueContainer().decode(Double.self))"
        if decoder.codingPath.count > 2 {
            metricType = FinancialRatioMetricType(rawValue: decoder.codingPath[2].stringValue)
        }
    }
}

enum FinancialRatioMetricType: String, Codable {
    case currentRatio = "Current ratio"
    case quickRatio = "Quick ratio"
    case cashRatio = "Cash ratio"
    case daysOfSalesOutstanding = "Days of sales outstanding"
    case daysOfInventoryOutstanding = "Days of inventory outstanding"
    case operatingCycle = "Operating cycle"
    case daysOfPayablesOutstanding = "Days of payables outstanding"
    case cashConversionCycle = "Cash conversion cycle"
    case grossProfitMargin = "Gross profit margin"
    case operatingProfitMargin = "Operating profit margin"
    case pretaxProfitMargin = "Pre-tax profit margin"
    case netProfitMargin = "Net profit margin"
    case effectiveTaxRate = "Effective tax rate"
    case returnOnAssets = "ROA"
    case returnOnEquity = "ROE"
    case returnOnCapitalEmployed = "ROI"
    case debtRatio = "Debt ratio"
    case debtEquityRatio = "Debt/Equity"
    case longTermDebtToCapitalization = "LT debt/cap"
    case totalDebtToCapitalization = "Total debt/cap"
    case interestCoverage = "Interest coverage"
    case cashFlowToDebtRatio = "CF/debt"
    case companyEquityMultiplier = "Equity multiplier"
    case receivablesTurnover = "Receivables turnover"
    case payablesTurnover = "Payables turnover"
    case inventoryTurnover = "Inventory turnover"
    case fixedAssetTurnover = "Fixed assets turnover"
    case assetTurnover = "Asset turnover"
    case operatingCashFlowPerShare = "OCF/Sh"
    case freeCashFlowPerShare = "FCF/Sh"
    case cashPerShare = "Cash/Sh"
    case payoutRatio = "Payout ratio"
    case operatingCashFlowSalesRatio = "OCF/Sales"
    case freeCashFlowOperatingCashFlowRatio = "FCF/OCF"
    case cashFlowCoverageRatios = "Cash flow coverage ratio"
    case shortTermCoverageRatios = "Short term coverage ratio"
    case capitalExpenditureCoverageRatio = "Cap-ex coverage ratio"
    case dividendPaidAndCapexCoverageRatio = "Div + Cap-ex coverage ratio"
    case priceToBookRatio = "P/B"
    case priceToSalesRatio = "P/S"
    case priceEarningsRatio = "P/E"
    case priceToFreeCashFlowsRatio = "P/FCF"
    case priceToOperatingCashFlowsRatio = "P/OCF"
    case priceCashFlowRatio = "P/CF"
    case priceEarningsToGrowthRatio = "PEG"
    case dividendYield = "Dividend yield"
    case enterpriseValueMultiple = "EV multiple"
    case priceFairValue = "P/FV"

    var text: String {
       return rawValue
    }
}

struct FinancialRatiosArray: Codable {
    var symbol: String
    var financials: [FinancialRatios]?

    func periodicValues(metric: Metric) -> [Double] {
        guard let financials = financials?.sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        }) else { return [] }
        
        var mapped: [Double] = []
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(mtc.value.doubleValue ?? 0)
            }
        }

        return mapped
    }

    func percentageIncrease(metric: Metric) -> [Double] {
        guard let financials = financials?.sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        }) else { return [] }

        var mapped: [Double] = []
        var previousValue: Double = 0
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                let value = mtc.value.doubleValue ?? 0
                let percentage = previousValue == 0 ? 0 :
                    previousValue < 0 ? ((previousValue - value) / previousValue) * 100 :
                    (-(previousValue - value) / previousValue) * 100
                previousValue = value
                mapped.append(percentage)
            }
        }

        return mapped.reversed()
    }
}

struct FinancialRatios: Codable {
    var symbol: String
    var date: String
    var currentRatio: FinancialRatioFinancialMetric
    var quickRatio: FinancialRatioFinancialMetric
    var cashRatio: FinancialRatioFinancialMetric
    var daysOfSalesOutstanding: FinancialRatioFinancialMetric
    var daysOfInventoryOutstanding: FinancialRatioFinancialMetric
    var operatingCycle: FinancialRatioFinancialMetric
    var daysOfPayablesOutstanding: FinancialRatioFinancialMetric
    var cashConversionCycle: FinancialRatioFinancialMetric
    var grossProfitMargin: FinancialRatioFinancialMetric
    var operatingProfitMargin: FinancialRatioFinancialMetric
    var pretaxProfitMargin: FinancialRatioFinancialMetric
    var netProfitMargin: FinancialRatioFinancialMetric
    var effectiveTaxRate: FinancialRatioFinancialMetric
    var returnOnAssets: FinancialRatioFinancialMetric
    var returnOnEquity: FinancialRatioFinancialMetric
    var returnOnCapitalEmployed: FinancialRatioFinancialMetric
    var debtRatio: FinancialRatioFinancialMetric
    var debtEquityRatio: FinancialRatioFinancialMetric
    var longTermDebtToCapitalization: FinancialRatioFinancialMetric?
    var totalDebtToCapitalization: FinancialRatioFinancialMetric?
    var interestCoverage: FinancialRatioFinancialMetric?
    var cashFlowToDebtRatio: FinancialRatioFinancialMetric?
    var companyEquityMultiplier: FinancialRatioFinancialMetric
    var receivablesTurnover: FinancialRatioFinancialMetric
    var payablesTurnover: FinancialRatioFinancialMetric
    var inventoryTurnover: FinancialRatioFinancialMetric
    var fixedAssetTurnover: FinancialRatioFinancialMetric
    var assetTurnover: FinancialRatioFinancialMetric
    var operatingCashFlowPerShare: FinancialRatioFinancialMetric
    var freeCashFlowPerShare: FinancialRatioFinancialMetric
    var cashPerShare: FinancialRatioFinancialMetric
    var payoutRatio: FinancialRatioFinancialMetric?
    var operatingCashFlowSalesRatio: FinancialRatioFinancialMetric
    var freeCashFlowOperatingCashFlowRatio: FinancialRatioFinancialMetric
    var cashFlowCoverageRatios: FinancialRatioFinancialMetric?
    var shortTermCoverageRatios: FinancialRatioFinancialMetric?
    var capitalExpenditureCoverageRatio: FinancialRatioFinancialMetric
    var dividendPaidAndCapexCoverageRatio: FinancialRatioFinancialMetric?
    var priceToBookRatio: FinancialRatioFinancialMetric
    var priceToSalesRatio: FinancialRatioFinancialMetric
    var priceEarningsRatio: FinancialRatioFinancialMetric
    var priceToFreeCashFlowsRatio: FinancialRatioFinancialMetric
    var priceToOperatingCashFlowsRatio: FinancialRatioFinancialMetric
    var priceCashFlowRatio: FinancialRatioFinancialMetric
    var priceEarningsToGrowthRatio: FinancialRatioFinancialMetric
    var dividendYield: FinancialRatioFinancialMetric?
    var enterpriseValueMultiple: FinancialRatioFinancialMetric
    var priceFairValue: FinancialRatioFinancialMetric
    
    var metrics: [FinancialRatioFinancialMetric] {
        let arr: NSMutableArray = [currentRatio, quickRatio, cashRatio, daysOfSalesOutstanding, daysOfInventoryOutstanding, operatingCycle, daysOfPayablesOutstanding, cashConversionCycle, grossProfitMargin, operatingProfitMargin, pretaxProfitMargin, netProfitMargin, effectiveTaxRate, returnOnAssets, returnOnEquity, returnOnCapitalEmployed, debtRatio, debtEquityRatio, companyEquityMultiplier, receivablesTurnover, payablesTurnover, inventoryTurnover, fixedAssetTurnover, assetTurnover, operatingCashFlowPerShare, freeCashFlowPerShare, cashPerShare, operatingCashFlowSalesRatio, freeCashFlowOperatingCashFlowRatio, capitalExpenditureCoverageRatio, priceToBookRatio, priceToSalesRatio, priceEarningsRatio, priceToFreeCashFlowsRatio, priceToOperatingCashFlowsRatio, priceCashFlowRatio, priceEarningsToGrowthRatio, enterpriseValueMultiple, priceFairValue]
        if let payoutRatio = payoutRatio {
            arr.add(payoutRatio)
        }
        if let dividendPaidAndCapexCoverageRatio = dividendPaidAndCapexCoverageRatio {
                   arr.add(dividendPaidAndCapexCoverageRatio)
               }
        if let dividendYield = dividendYield {
                   arr.add(dividendYield)
               }
        if let cashFlowCoverageRatios = cashFlowCoverageRatios {
                   arr.add(cashFlowCoverageRatios)
               }
        if let shortTermCoverageRatios = shortTermCoverageRatios {
                   arr.add(shortTermCoverageRatios)
               }
        if let cashFlowToDebtRatio = cashFlowToDebtRatio {
            arr.add(cashFlowToDebtRatio)
        }
        if let interestCoverage = interestCoverage {
            arr.add(interestCoverage)
        }
        if let totalDebtToCapitalization = totalDebtToCapitalization {
            arr.add(totalDebtToCapitalization)
        }
        if let longTermDebtToCapitalization = longTermDebtToCapitalization {
            arr.add(longTermDebtToCapitalization)
        }
        
        return arr as? [FinancialRatioFinancialMetric] ?? []
    }
}
