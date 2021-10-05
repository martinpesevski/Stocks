//
//  FinancialRatios.swift
//  Stocker
//
//  Created by Martin Peshevski on 8/28/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct FinancialRatioFinancialMetric: Codable, Metric {
    var stringValue: String
    let doubleValue: Double
    var metricType: AnyMetricType?

    init(from decoder: Decoder) throws {
        if let decoderValue = decoder.codingPath[safe: 1]?.stringValue,
            let decodedType = FinancialRatioMetricType(rawValue: decoderValue) {
            metricType = AnyMetricType(decodedType)
        }
        doubleValue = try decoder.singleValueContainer().decode(Double?.self) ?? 0
        stringValue = ""
        stringValue = (metricSuffixType == .percentage ? "\(doubleValue * 100)".twoDigits : "\("\(doubleValue)".twoDigits.roundedWithAbbreviations)").formatted(metricSuffixType)
    }
}

enum FinancialRatioMetricType: String, Codable, MetricType, CaseIterable {
    case currentRatio                       = "currentRatio"
    case quickRatio                         = "quickRatio"
    case cashRatio                          = "cashRatio"
    case daysOfSalesOutstanding             = "daysOfSalesOutstanding"
    case daysOfInventoryOutstanding         = "daysOfInventoryOutstanding"
    case operatingCycle                     = "operatingCycle"
    case daysOfPayablesOutstanding          = "daysOfPayablesOutstanding"
    case cashConversionCycle                = "cashConversionCycle"
    case grossProfitMargin                  = "grossProfitMargin"
    case operatingProfitMargin              = "operatingProfitMargin"
    case pretaxProfitMargin                 = "pretaxProfitMargin"
    case netProfitMargin                    = "netProfitMargin"
    case effectiveTaxRate                   = "effectiveTaxRate"
    case returnOnAssets                     = "returnOnAssets"
    case returnOnEquity                     = "returnOnEquity"
    case returnOnCapitalEmployed            = "returnOnCapitalEmployed"
    case debtRatio                          = "debtRatio"
    case debtEquityRatio                    = "debtEquityRatio"
    case longTermDebtToCapitalization       = "longTermDebtToCapitalization"
    case totalDebtToCapitalization          = "totalDebtToCapitalization"
    case interestCoverage                   = "interestCoverage"
    case cashFlowToDebtRatio                = "cashFlowToDebtRatio"
    case companyEquityMultiplier            = "companyEquityMultiplier"
    case receivablesTurnover                = "receivablesTurnover"
    case payablesTurnover                   = "payablesTurnover"
    case inventoryTurnover                  = "inventoryTurnover"
    case fixedAssetTurnover                 = "fixedAssetTurnover"
    case assetTurnover                      = "assetTurnover"
    case operatingCashFlowPerShare          = "operatingCashFlowPerShare"
    case freeCashFlowPerShare               = "freeCashFlowPerShare"
    case cashPerShare                       = "cashPerShare"
    case payoutRatio                        = "payoutRatio"
    case operatingCashFlowSalesRatio        = "operatingCashFlowSalesRatio"
    case freeCashFlowOperatingCashFlowRatio = "freeCashFlowOperatingCashFlowRatio"
    case cashFlowCoverageRatios             = "cashFlowCoverageRatios"
    case shortTermCoverageRatios            = "shortTermCoverageRatios"
    case capitalExpenditureCoverageRatio    = "capitalExpenditureCoverageRatio"
    case dividendPaidAndCapexCoverageRatio  = "dividendPaidAndCapexCoverageRatio"
    case priceToBookRatio                   = "priceToBookRatio"
    case priceToSalesRatio                  = "priceToSalesRatio"
    case priceEarningsRatio                 = "priceEarningsRatio"
    case priceToFreeCashFlowsRatio          = "priceToFreeCashFlowsRatio"
    case priceToOperatingCashFlowsRatio     = "priceToOperatingCashFlowsRatio"
    case priceCashFlowRatio                 = "priceCashFlowRatio"
    case priceEarningsToGrowthRatio         = "priceEarningsToGrowthRatio"
    case dividendYield                      = "dividendYield"
    case enterpriseValueMultiple            = "enterpriseValueMultiple"
    case priceFairValue                     = "priceFairValue"

    var text: String {
        switch self {
        case .currentRatio                       : return "Current ratio"
        case .quickRatio                         : return "Quick ratio"
        case .cashRatio                          : return "Cash ratio"
        case .daysOfSalesOutstanding             : return "Days of sales outstanding"
        case .daysOfInventoryOutstanding         : return "Days of inventory outstanding"
        case .operatingCycle                     : return "Operating cycle"
        case .daysOfPayablesOutstanding          : return "Days of payables outstanding"
        case .cashConversionCycle                : return "Cash conversion cycle"
        case .grossProfitMargin                  : return "Gross profit margin"
        case .operatingProfitMargin              : return "Operating profit margin"
        case .pretaxProfitMargin                 : return "Pre-tax profit margin"
        case .netProfitMargin                    : return "Net profit margin"
        case .effectiveTaxRate                   : return "Effective tax rate"
        case .returnOnAssets                     : return "ROA"
        case .returnOnEquity                     : return "ROE"
        case .returnOnCapitalEmployed            : return "ROI"
        case .debtRatio                          : return "Debt ratio"
        case .debtEquityRatio                    : return "Debt/Equity"
        case .longTermDebtToCapitalization       : return "LT debt/cap"
        case .totalDebtToCapitalization          : return "Total debt/cap"
        case .interestCoverage                   : return "Interest coverage"
        case .cashFlowToDebtRatio                : return "CF/debt"
        case .companyEquityMultiplier            : return "Equity multiplier"
        case .receivablesTurnover                : return "Receivables turnover"
        case .payablesTurnover                   : return "Payables turnover"
        case .inventoryTurnover                  : return "Inventory turnover"
        case .fixedAssetTurnover                 : return "Fixed assets turnover"
        case .assetTurnover                      : return "Asset turnover"
        case .operatingCashFlowPerShare          : return "OCF/Sh"
        case .freeCashFlowPerShare               : return "FCF/Sh"
        case .cashPerShare                       : return "Cash/Sh"
        case .payoutRatio                        : return "Payout ratio"
        case .operatingCashFlowSalesRatio        : return "OCF/Sales"
        case .freeCashFlowOperatingCashFlowRatio : return "FCF/OCF"
        case .cashFlowCoverageRatios             : return "Cash flow coverage ratio"
        case .shortTermCoverageRatios            : return "Short term coverage ratio"
        case .capitalExpenditureCoverageRatio    : return "Cap-ex coverage ratio"
        case .dividendPaidAndCapexCoverageRatio  : return "Div + Cap-ex coverage ratio"
        case .priceToBookRatio                   : return "P/B"
        case .priceToSalesRatio                  : return "P/S"
        case .priceEarningsRatio                 : return "P/E"
        case .priceToFreeCashFlowsRatio          : return "P/FCF"
        case .priceToOperatingCashFlowsRatio     : return "P/OCF"
        case .priceCashFlowRatio                 : return "P/CF"
        case .priceEarningsToGrowthRatio         : return "PEG"
        case .dividendYield                      : return "Dividend yield"
        case .enterpriseValueMultiple            : return "EV multiple"
        case .priceFairValue                     : return "P/FV"
        }
    }
    
    var suffixType: MetricSuffixType {
        switch self {
        case .grossProfitMargin, .operatingProfitMargin, .pretaxProfitMargin, .netProfitMargin, .effectiveTaxRate, .returnOnAssets, .returnOnEquity, .returnOnCapitalEmployed, .dividendYield: return .percentage
        case .cashPerShare, .freeCashFlowPerShare, .operatingCashFlowPerShare: return .money
        default: return .none
        }
    }
    
    var filterType: MetricFilterType {
        switch self {
        case .grossProfitMargin, .operatingProfitMargin, .pretaxProfitMargin, .netProfitMargin, .effectiveTaxRate, .returnOnAssets, .returnOnEquity, .returnOnCapitalEmployed, .dividendYield, .cashPerShare, .freeCashFlowPerShare, .operatingCashFlowPerShare: return .percentageGrowth
        default: return .metric
        }
    }
}

struct FinancialRatios: Codable, Financial {
    var symbol                             : String
    var date                               : String
    var period                             : FiscalPeriod
    var currentRatio                       : FinancialRatioFinancialMetric?
    var quickRatio                         : FinancialRatioFinancialMetric?
    var cashRatio                          : FinancialRatioFinancialMetric?
    var daysOfSalesOutstanding             : FinancialRatioFinancialMetric?
    var daysOfInventoryOutstanding         : FinancialRatioFinancialMetric?
    var operatingCycle                     : FinancialRatioFinancialMetric?
    var daysOfPayablesOutstanding          : FinancialRatioFinancialMetric?
    var cashConversionCycle                : FinancialRatioFinancialMetric?
    var grossProfitMargin                  : FinancialRatioFinancialMetric?
    var operatingProfitMargin              : FinancialRatioFinancialMetric?
    var pretaxProfitMargin                 : FinancialRatioFinancialMetric?
    var netProfitMargin                    : FinancialRatioFinancialMetric?
    var effectiveTaxRate                   : FinancialRatioFinancialMetric?
    var returnOnAssets                     : FinancialRatioFinancialMetric?
    var returnOnEquity                     : FinancialRatioFinancialMetric?
    var returnOnCapitalEmployed            : FinancialRatioFinancialMetric?
    var debtRatio                          : FinancialRatioFinancialMetric?
    var debtEquityRatio                    : FinancialRatioFinancialMetric?
    var longTermDebtToCapitalization       : FinancialRatioFinancialMetric?
    var totalDebtToCapitalization          : FinancialRatioFinancialMetric?
    var interestCoverage                   : FinancialRatioFinancialMetric?
    var cashFlowToDebtRatio                : FinancialRatioFinancialMetric?
    var companyEquityMultiplier            : FinancialRatioFinancialMetric?
    var receivablesTurnover                : FinancialRatioFinancialMetric?
    var payablesTurnover                   : FinancialRatioFinancialMetric?
    var inventoryTurnover                  : FinancialRatioFinancialMetric?
    var fixedAssetTurnover                 : FinancialRatioFinancialMetric?
    var assetTurnover                      : FinancialRatioFinancialMetric?
    var operatingCashFlowPerShare          : FinancialRatioFinancialMetric?
    var freeCashFlowPerShare               : FinancialRatioFinancialMetric?
    var cashPerShare                       : FinancialRatioFinancialMetric?
    var payoutRatio                        : FinancialRatioFinancialMetric?
    var operatingCashFlowSalesRatio        : FinancialRatioFinancialMetric?
    var freeCashFlowOperatingCashFlowRatio : FinancialRatioFinancialMetric?
    var cashFlowCoverageRatios             : FinancialRatioFinancialMetric?
    var shortTermCoverageRatios            : FinancialRatioFinancialMetric?
    var capitalExpenditureCoverageRatio    : FinancialRatioFinancialMetric?
    var dividendPaidAndCapexCoverageRatio  : FinancialRatioFinancialMetric?
    var priceToBookRatio                   : FinancialRatioFinancialMetric?
    var priceToSalesRatio                  : FinancialRatioFinancialMetric?
    var priceEarningsRatio                 : FinancialRatioFinancialMetric?
    var priceToFreeCashFlowsRatio          : FinancialRatioFinancialMetric?
    var priceToOperatingCashFlowsRatio     : FinancialRatioFinancialMetric?
    var priceCashFlowRatio                 : FinancialRatioFinancialMetric?
    var priceEarningsToGrowthRatio         : FinancialRatioFinancialMetric?
    var dividendYield                      : FinancialRatioFinancialMetric?
    var enterpriseValueMultiple            : FinancialRatioFinancialMetric?
    var priceFairValue                     : FinancialRatioFinancialMetric?
    
    var metrics: [AnyMetric] {
        let arr: NSMutableArray = []
        
        if let priceFairValue                     = priceFairValue { arr.add(AnyMetric(priceFairValue)) }
        if let enterpriseValueMultiple            = enterpriseValueMultiple { arr.add(AnyMetric(enterpriseValueMultiple)) }
        if let priceEarningsToGrowthRatio         = priceEarningsToGrowthRatio { arr.add(AnyMetric(priceEarningsToGrowthRatio)) }
        if let priceCashFlowRatio                 = priceCashFlowRatio { arr.add(AnyMetric(priceCashFlowRatio)) }
        if let priceToOperatingCashFlowsRatio     = priceToOperatingCashFlowsRatio { arr.add(AnyMetric(priceToOperatingCashFlowsRatio)) }
        if let priceToFreeCashFlowsRatio          = priceToFreeCashFlowsRatio { arr.add(AnyMetric(priceToFreeCashFlowsRatio)) }
        if let priceEarningsRatio                 = priceEarningsRatio { arr.add(AnyMetric(priceEarningsRatio)) }
        if let priceToSalesRatio                  = priceToSalesRatio { arr.add(AnyMetric(priceToSalesRatio)) }
        if let priceToBookRatio                   = priceToBookRatio { arr.add(AnyMetric(priceToBookRatio)) }
        if let capitalExpenditureCoverageRatio    = capitalExpenditureCoverageRatio { arr.add(AnyMetric(capitalExpenditureCoverageRatio)) }
        if let freeCashFlowOperatingCashFlowRatio = freeCashFlowOperatingCashFlowRatio { arr.add(AnyMetric(freeCashFlowOperatingCashFlowRatio)) }
        if let operatingCashFlowSalesRatio        = operatingCashFlowSalesRatio { arr.add(AnyMetric(operatingCashFlowSalesRatio)) }
        if let freeCashFlowPerShare               = freeCashFlowPerShare { arr.add(AnyMetric(freeCashFlowPerShare)) }
        if let operatingCashFlowPerShare          = operatingCashFlowPerShare { arr.add(AnyMetric(operatingCashFlowPerShare)) }
        if let assetTurnover                      = assetTurnover { arr.add(AnyMetric(assetTurnover)) }
        if let fixedAssetTurnover                 = fixedAssetTurnover { arr.add(AnyMetric(fixedAssetTurnover)) }
        if let inventoryTurnover                  = inventoryTurnover { arr.add(AnyMetric(inventoryTurnover)) }
        if let payablesTurnover                   = payablesTurnover { arr.add(AnyMetric(payablesTurnover)) }
        if let receivablesTurnover                = receivablesTurnover { arr.add(AnyMetric(receivablesTurnover)) }
        if let companyEquityMultiplier            = companyEquityMultiplier { arr.add(AnyMetric(companyEquityMultiplier)) }
        if let debtEquityRatio                    = debtEquityRatio { arr.add(AnyMetric(debtEquityRatio)) }
        if let debtRatio                          = debtRatio { arr.add(AnyMetric(debtRatio)) }
        if let returnOnCapitalEmployed            = returnOnCapitalEmployed { arr.add(AnyMetric(returnOnCapitalEmployed)) }
        if let returnOnEquity                     = returnOnEquity { arr.add(AnyMetric(returnOnEquity)) }
        if let returnOnAssets                     = returnOnAssets { arr.add(AnyMetric(returnOnAssets)) }
        if let effectiveTaxRate                   = effectiveTaxRate { arr.add(AnyMetric(effectiveTaxRate)) }
        if let netProfitMargin                    = netProfitMargin { arr.add(AnyMetric(netProfitMargin)) }
        if let pretaxProfitMargin                 = pretaxProfitMargin { arr.add(AnyMetric(pretaxProfitMargin)) }
        if let operatingProfitMargin              = operatingProfitMargin { arr.add(AnyMetric(operatingProfitMargin)) }
        if let grossProfitMargin                  = grossProfitMargin { arr.add(AnyMetric(grossProfitMargin)) }
        if let cashConversionCycle                = cashConversionCycle { arr.add(AnyMetric(cashConversionCycle)) }
        if let daysOfPayablesOutstanding          = daysOfPayablesOutstanding { arr.add(AnyMetric(daysOfPayablesOutstanding)) }
        if let operatingCycle                     = operatingCycle { arr.add(AnyMetric(operatingCycle)) }
        if let daysOfInventoryOutstanding         = daysOfInventoryOutstanding { arr.add(AnyMetric(daysOfInventoryOutstanding)) }
        if let daysOfSalesOutstanding             = daysOfSalesOutstanding { arr.add(AnyMetric(daysOfSalesOutstanding)) }
        if let cashRatio                          = cashRatio { arr.add(AnyMetric(cashRatio)) }
        if let quickRatio                         = quickRatio { arr.add(AnyMetric(quickRatio)) }
        if let currentRatio                       = currentRatio { arr.add(AnyMetric(currentRatio)) }
        if let payoutRatio                        = payoutRatio { arr.add(AnyMetric(payoutRatio)) }
        if let dividendPaidAndCapexCoverageRatio  = dividendPaidAndCapexCoverageRatio { arr.add(AnyMetric(dividendPaidAndCapexCoverageRatio)) }
        if let dividendYield                      = dividendYield { arr.add(AnyMetric(dividendYield)) }
        if let cashFlowCoverageRatios             = cashFlowCoverageRatios { arr.add(AnyMetric(cashFlowCoverageRatios)) }
        if let shortTermCoverageRatios            = shortTermCoverageRatios { arr.add(AnyMetric(shortTermCoverageRatios)) }
        if let cashFlowToDebtRatio                = cashFlowToDebtRatio { arr.add(AnyMetric(cashFlowToDebtRatio)) }
        if let interestCoverage                   = interestCoverage { arr.add(AnyMetric(interestCoverage)) }
        if let totalDebtToCapitalization          = totalDebtToCapitalization { arr.add(AnyMetric(totalDebtToCapitalization)) }
        if let longTermDebtToCapitalization       = longTermDebtToCapitalization { arr.add(AnyMetric(longTermDebtToCapitalization)) }
        
        return arr as? [AnyMetric] ?? []
    }
}
