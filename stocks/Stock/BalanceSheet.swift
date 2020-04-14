//
//  BalanceSheet.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum FiscalPeriod: String, Codable {
    case annual = "FY"
    case firstQuarter = "Q1"
    case secondQuarter = "Q2"
    case thirdQuarter = "Q3"
    case fourthQuarter = "Q4"
}

struct BalanceSheetFinancialMetric<T: Codable>: Codable {
    let value: T
    var metricType: BalanceSheetMetricType?
    
    init(from decoder: Decoder) throws {
        value = try decoder.singleValueContainer().decode(T.self)
        if decoder.codingPath.count > 1 {
            metricType = BalanceSheetMetricType(rawValue: decoder.codingPath[1].stringValue)
        }
    }
}

enum BalanceSheetMetricType: String, Codable {
    case cashAndCashEquivalents = "cashAndCashEquivalents"
    case shortTermInvestments = "shortTermInvestments"
    case cashAndShortTermInvestments = "cashAndShortTermInvestments"
    case netReceivables = "netReceivables"
    case inventory = "inventory"
    case otherCurrentAssets = "otherCurrentAssets"
    case totalCurrentAssets = "totalCurrentAssets"
    case propertyPlantEquipmentNet = "propertyPlantEquipmentNet"
    case goodwill = "goodwill"
    case intangibleAssets = "intangibleAssets"
    case goodwillAndIntangibleAssets = "goodwillAndIntangibleAssets"
    case longTermInvestments = "longTermInvestments"
    case taxAssets = "taxAssets"
    case otherNonCurrentAssets = "otherNonCurrentAssets"
    case totalNonCurrentAssets = "totalNonCurrentAssets"
    case otherAssets = "otherAssets"
    case totalAssets = "totalAssets"
    case accountPayables = "accountPayables"
    case shortTermDebt = "shortTermDebt"
    case taxPayables = "taxPayables"
    case deferredRevenue = "deferredRevenue"
    case otherCurrentLiabilities = "otherCurrentLiabilities"
    case totalCurrentLiabilities = "totalCurrentLiabilities"
    case longTermDebt = "longTermDebt"
    case deferredRevenueNonCurrent = "deferredRevenueNonCurrent"
    case deferrredTaxLiabilitiesNonCurrent = "deferrredTaxLiabilitiesNonCurrent"
    case otherNonCurrentLiabilities = "otherNonCurrentLiabilities"
    case totalNonCurrentLiabilities = "totalNonCurrentLiabilities"
    case otherLiabilities = "otherLiabilities"
    case totalLiabilities = "totalLiabilities"
    case commonStock = "commonStock"
    case retainedEarnings = "retainedEarnings"
    case accumulatedOtherComprehensiveIncomeLoss = "accumulatedOtherComprehensiveIncomeLoss"
    case othertotalStockholdersEquity = "othertotalStockholdersEquity"
    case totalStockholdersEquity = "totalStockholdersEquity"
    case totalLiabilitiesAndStockholdersEquity = "totalLiabilitiesAndStockholdersEquity"
    case totalInvestments = "totalInvestments"
    case totalDebt = "totalDebt"
    case netDebt = "netDebt"
    
    var text: String {
        switch self {
        case .cashAndCashEquivalents: return "Cash and cash equivalents"
        case .shortTermInvestments: return "Short term investments"
        case .cashAndShortTermInvestments: return "Cash and short term investments"
        case .netReceivables: return "Net receivables"
        case .inventory: return "Inventory"
        case .otherCurrentAssets: return "Other current assets"
        case .totalCurrentAssets: return "Total current assets"
        case .propertyPlantEquipmentNet: return "Property plant equipment net"
        case .goodwill: return "Goodwill"
        case .intangibleAssets: return "Intangible assets"
        case .goodwillAndIntangibleAssets: return "Goodwill and intangible assets"
        case .longTermInvestments: return "Long term investments"
        case .taxAssets: return "Tax assets"
        case .otherNonCurrentAssets: return "Other non current assets"
        case .totalNonCurrentAssets: return "Total non current assets"
        case .otherAssets: return "Other assets"
        case .totalAssets: return "Total assets"
        case .accountPayables: return "Account payables"
        case .shortTermDebt: return "Short term debt"
        case .taxPayables: return "Tax payables"
        case .deferredRevenue: return "Deferred revenue"
        case .otherCurrentLiabilities: return "Other current liabilities"
        case .totalCurrentLiabilities: return "Total current liabilities"
        case .longTermDebt: return "Long term debt"
        case .deferredRevenueNonCurrent: return "Deferred revenue non current"
        case .deferrredTaxLiabilitiesNonCurrent: return "Deferrred tax liabilities non current"
        case .otherNonCurrentLiabilities: return "Other non current liabilities"
        case .totalNonCurrentLiabilities: return "Total non current liabilities"
        case .otherLiabilities: return "Other liabilities"
        case .totalLiabilities: return "Total liabilities"
        case .commonStock: return "Common stock"
        case .retainedEarnings: return "Retained earnings"
        case .accumulatedOtherComprehensiveIncomeLoss: return "Accumulated other comprehensive income/loss"
        case .othertotalStockholdersEquity: return "Other total stockholders equity"
        case .totalStockholdersEquity: return "Total stockholders equity"
        case .totalLiabilitiesAndStockholdersEquity: return "Total liabilities and stockholders equity"
        case .totalInvestments: return "Total investments"
        case .totalDebt: return "Total debt"
        case .netDebt: return "Net debt"
        }
    }
}

struct BalanceSheet: Codable, StockIdentifiable {
    var date: String
    var symbol: String
    var period: FiscalPeriod
    var cashAndCashEquivalents: BalanceSheetFinancialMetric<Double>
    var shortTermInvestments: BalanceSheetFinancialMetric<Double>
    var cashAndShortTermInvestments: BalanceSheetFinancialMetric<Double>
    var netReceivables: BalanceSheetFinancialMetric<Double>
    var inventory: BalanceSheetFinancialMetric<Double>
    var otherCurrentAssets: BalanceSheetFinancialMetric<Double>
    var totalCurrentAssets: BalanceSheetFinancialMetric<Double>
    var propertyPlantEquipmentNet: BalanceSheetFinancialMetric<Double>
    var goodwill: BalanceSheetFinancialMetric<Double>
    var intangibleAssets: BalanceSheetFinancialMetric<Double>
    var goodwillAndIntangibleAssets: BalanceSheetFinancialMetric<Double>
    var longTermInvestments: BalanceSheetFinancialMetric<Double>
    var taxAssets: BalanceSheetFinancialMetric<Double>
    var otherNonCurrentAssets: BalanceSheetFinancialMetric<Double>
    var totalNonCurrentAssets: BalanceSheetFinancialMetric<Double>
    var otherAssets: BalanceSheetFinancialMetric<Double>
    var totalAssets: BalanceSheetFinancialMetric<Double>
    var accountPayables: BalanceSheetFinancialMetric<Double>
    var shortTermDebt: BalanceSheetFinancialMetric<Double>
    var taxPayables: BalanceSheetFinancialMetric<Double>
    var deferredRevenue: BalanceSheetFinancialMetric<Double>
    var otherCurrentLiabilities: BalanceSheetFinancialMetric<Double>
    var totalCurrentLiabilities: BalanceSheetFinancialMetric<Double>
    var longTermDebt: BalanceSheetFinancialMetric<Double>
    var deferredRevenueNonCurrent: BalanceSheetFinancialMetric<Double>
    var deferrredTaxLiabilitiesNonCurrent: BalanceSheetFinancialMetric<Double>
    var otherNonCurrentLiabilities: BalanceSheetFinancialMetric<Double>
    var totalNonCurrentLiabilities: BalanceSheetFinancialMetric<Double>
    var otherLiabilities: BalanceSheetFinancialMetric<Double>
    var totalLiabilities: BalanceSheetFinancialMetric<Double>
    var commonStock: BalanceSheetFinancialMetric<Double>
    var retainedEarnings: BalanceSheetFinancialMetric<Double>
    var accumulatedOtherComprehensiveIncomeLoss: BalanceSheetFinancialMetric<Double>
    var othertotalStockholdersEquity: BalanceSheetFinancialMetric<Double>
    var totalStockholdersEquity: BalanceSheetFinancialMetric<Double>
    var totalLiabilitiesAndStockholdersEquity: BalanceSheetFinancialMetric<Double>
    var totalInvestments: BalanceSheetFinancialMetric<Double>
    var totalDebt: BalanceSheetFinancialMetric<Double>
    var netDebt: BalanceSheetFinancialMetric<Double>
    
    var metrics: [BalanceSheetFinancialMetric<Double>] {
        [cashAndCashEquivalents, shortTermInvestments, cashAndShortTermInvestments, netReceivables, inventory, otherCurrentAssets, totalCurrentAssets, propertyPlantEquipmentNet, goodwill, intangibleAssets, goodwillAndIntangibleAssets, longTermInvestments, taxAssets, otherNonCurrentAssets, totalNonCurrentAssets, otherAssets, totalAssets, accountPayables, shortTermDebt, taxPayables, deferredRevenue, otherCurrentLiabilities, totalCurrentLiabilities, longTermDebt, deferredRevenueNonCurrent, deferrredTaxLiabilitiesNonCurrent, otherNonCurrentLiabilities, totalNonCurrentLiabilities, otherLiabilities, totalLiabilities, commonStock, retainedEarnings, accumulatedOtherComprehensiveIncomeLoss, othertotalStockholdersEquity, totalStockholdersEquity, totalLiabilitiesAndStockholdersEquity, totalInvestments, totalDebt, netDebt]
    }
    
    static func stockIdentifier(_ ticker: String) -> String {
        return "balance sheet \(ticker)"
    }
}
