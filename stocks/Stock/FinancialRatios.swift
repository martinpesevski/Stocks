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
        if decoder.codingPath.count > 1 {
            metricType = FinancialRatioMetricType(rawValue: decoder.codingPath[1].stringValue)
        }
    }
}

enum FinancialRatioMetricType: String, Codable {
    case currentRatio = "currentRatio"
    case quickRatio = "quickRatio"
    case cashRatio = "cashRatio"
    case daysOfSalesOutstanding = "daysOfSalesOutstanding"
    case daysOfInventoryOutstanding = "daysOfInventoryOutstanding"
    case operatingCycle = "operatingCycle"
    case daysOfPayablesOutstanding = "daysOfPayablesOutstanding"
    case cashConversionCycle = "cashConversionCycle"
    case grossProfitMargin = "grossProfitMargin"
    case operatingProfitMargin = "operatingProfitMargin"
    case pretaxProfitMargin = "pretaxProfitMargin"
    case netProfitMargin = "netProfitMargin"
    case effectiveTaxRate = "effectiveTaxRate"
    case returnOnAssets = "returnOnAssets"
    case returnOnEquity = "returnOnEquity"
    case returnOnCapitalEmployed = "returnOnCapitalEmployed"
    case debtRatio = "debtRatio"
    case debtEquityRatio = "debtEquityRatio"
    case longTermDebtToCapitalization = "longTermDebtToCapitalization"
    case totalDebtToCapitalization = "totalDebtToCapitalization"
    case interestCoverage = "interestCoverage"
    case cashFlowToDebtRatio = "cashFlowToDebtRatio"
    case companyEquityMultiplier = "companyEquityMultiplier"
    case receivablesTurnover = "receivablesTurnover"
    case payablesTurnover = "payablesTurnover"
    case inventoryTurnover = "inventoryTurnover"
    case fixedAssetTurnover = "fixedAssetTurnover"
    case assetTurnover = "assetTurnover"
    case operatingCashFlowPerShare = "operatingCashFlowPerShare"
    case freeCashFlowPerShare = "freeCashFlowPerShare"
    case cashPerShare = "cashPerShare"
    case payoutRatio = "payoutRatio"
    case operatingCashFlowSalesRatio = "operatingCashFlowSalesRatio"
    case freeCashFlowOperatingCashFlowRatio = "freeCashFlowOperatingCashFlowRatio"
    case cashFlowCoverageRatios = "cashFlowCoverageRatios"
    case shortTermCoverageRatios = "shortTermCoverageRatios"
    case capitalExpenditureCoverageRatio = "capitalExpenditureCoverageRatio"
    case dividendPaidAndCapexCoverageRatio = "dividendPaidAndCapexCoverageRatio"
    case priceToBookRatio = "priceToBookRatio"
    case priceToSalesRatio = "priceToSalesRatio"
    case priceEarningsRatio = "priceEarningsRatio"
    case priceToFreeCashFlowsRatio = "priceToFreeCashFlowsRatio"
    case priceToOperatingCashFlowsRatio = "priceToOperatingCashFlowsRatio"
    case priceCashFlowRatio = "priceCashFlowRatio"
    case priceEarningsToGrowthRatio = "priceEarningsToGrowthRatio"
    case dividendYield = "dividendYield"
    case enterpriseValueMultiple = "enterpriseValueMultiple"
    case priceFairValue = "priceFairValue"

    var text: String {
        switch self {
        case .currentRatio: return "Current ratio"
        case .quickRatio: return "Quick ratio"
        case .cashRatio: return "Cash ratio"
        case .daysOfSalesOutstanding: return "Days of sales outstanding"
        case .daysOfInventoryOutstanding: return  "Days of inventory outstanding"
        case .operatingCycle: return "Operating cycle"
        case .daysOfPayablesOutstanding: return "Days of payables outstanding"
        case .cashConversionCycle: return "Cash conversion cycle"
        case .grossProfitMargin: return "Gross profit margin"
        case .operatingProfitMargin: return "Operating profit margin"
        case .pretaxProfitMargin: return "Pre-tax profit margin"
        case .netProfitMargin: return "Net profit margin"
        case .effectiveTaxRate: return "Effective tax rate"
        case .returnOnAssets: return "ROA"
        case .returnOnEquity: return "ROE"
        case .returnOnCapitalEmployed: return "ROI"
        case .debtRatio: return "Debt ratio"
        case .debtEquityRatio: return "Debt/Equity"
        case .longTermDebtToCapitalization: return "LT debt/cap"
        case .totalDebtToCapitalization: return "Total debt/cap"
        case .interestCoverage: return "Interest coverage"
        case .cashFlowToDebtRatio: return "CF/debt"
        case .companyEquityMultiplier: return "Equity multiplier"
        case .receivablesTurnover: return "Receivables turnover"
        case .payablesTurnover: return "Payables turnover"
        case .inventoryTurnover: return "Inventory turnover"
        case .fixedAssetTurnover: return "Fixed assets turnover"
        case .assetTurnover: return "Asset turnover"
        case .operatingCashFlowPerShare: return "OCF/Sh"
        case .freeCashFlowPerShare: return "FCF/Sh"
        case .cashPerShare: return "Cash/Sh"
        case .payoutRatio: return "Payout ratio"
        case .operatingCashFlowSalesRatio: return "OCF/Sales"
        case .freeCashFlowOperatingCashFlowRatio: return "FCF/OCF"
        case .cashFlowCoverageRatios: return "Cash flow coverage ratio"
        case .shortTermCoverageRatios: return "Short term coverage ratio"
        case .capitalExpenditureCoverageRatio: return "Cap-ex coverage ratio"
        case .dividendPaidAndCapexCoverageRatio: return "Div + Cap-ex coverage ratio"
        case .priceToBookRatio: return "P/B"
        case .priceToSalesRatio: return "P/S"
        case .priceEarningsRatio: return "P/E"
        case .priceToFreeCashFlowsRatio: return "P/FCF"
        case .priceToOperatingCashFlowsRatio: return "P/OCF"
        case .priceCashFlowRatio: return "P/CF"
        case .priceEarningsToGrowthRatio: return "PEG"
        case .dividendYield: return "Dividend yield"
        case .enterpriseValueMultiple: return "EV multiple"
        case .priceFairValue: return "P/FV"
        }
    }
}

extension Collection where Iterator.Element == FinancialRatios {
    var symbol: String {
        self[safe: 0 as! Self.Index]?.symbol ?? ""
    }
    
    func latestValue(metric: Metric) -> String {
        guard let financial = self.sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        }).first else { return "" }
        
        for mtc in financial.metrics where mtc.metricType?.text == metric.text {
            return String(format: "%.5f", mtc.value.doubleValue ?? 0)
        }
        
        return ""
    }
    
    func periodicValues(metric: Metric) -> [Double] {
        let financials = self.sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        })
        
        var mapped: [Double] = []
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(mtc.value.doubleValue ?? 0)
            }
        }

        return mapped
    }

    func percentageIncrease(metric: Metric) -> [Double] {
        let financials = self.sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        })

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
        
        if let payoutRatio = payoutRatio { arr.add(payoutRatio) }
        if let dividendPaidAndCapexCoverageRatio = dividendPaidAndCapexCoverageRatio { arr.add(dividendPaidAndCapexCoverageRatio) }
        if let dividendYield = dividendYield { arr.add(dividendYield) }
        if let cashFlowCoverageRatios = cashFlowCoverageRatios { arr.add(cashFlowCoverageRatios) }
        if let shortTermCoverageRatios = shortTermCoverageRatios { arr.add(shortTermCoverageRatios) }
        if let cashFlowToDebtRatio = cashFlowToDebtRatio { arr.add(cashFlowToDebtRatio) }
        if let interestCoverage = interestCoverage { arr.add(interestCoverage) }
        if let totalDebtToCapitalization = totalDebtToCapitalization { arr.add(totalDebtToCapitalization) }
        if let longTermDebtToCapitalization = longTermDebtToCapitalization { arr.add(longTermDebtToCapitalization) }
        
        return arr as? [FinancialRatioFinancialMetric] ?? []
    }
}
