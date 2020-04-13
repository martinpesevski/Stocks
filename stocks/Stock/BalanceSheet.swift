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

struct FinancialMetric<T: Codable>: Codable {
    let value: T
    var metricType: FinancialMetricType?
    
    init(from decoder: Decoder) throws {
        value = try decoder.singleValueContainer().decode(T.self)
        if decoder.codingPath.count > 1 {
            metricType = FinancialMetricType(rawValue: decoder.codingPath[1].stringValue )
        }
    }
}

enum FinancialMetricType: String, Codable {
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
    var cashAndCashEquivalents: FinancialMetric<Double>
    var shortTermInvestments: FinancialMetric<Double>
    var cashAndShortTermInvestments: FinancialMetric<Double>
    var netReceivables: FinancialMetric<Double>
    var inventory: FinancialMetric<Double>
    var otherCurrentAssets: FinancialMetric<Double>
    var totalCurrentAssets: FinancialMetric<Double>
    var propertyPlantEquipmentNet: FinancialMetric<Double>
    var goodwill: FinancialMetric<Double>
    var intangibleAssets: FinancialMetric<Double>
    var goodwillAndIntangibleAssets: FinancialMetric<Double>
    var longTermInvestments: FinancialMetric<Double>
    var taxAssets: FinancialMetric<Double>
    var otherNonCurrentAssets: FinancialMetric<Double>
    var totalNonCurrentAssets: FinancialMetric<Double>
    var otherAssets: FinancialMetric<Double>
    var totalAssets: FinancialMetric<Double>
    var accountPayables: FinancialMetric<Double>
    var shortTermDebt: FinancialMetric<Double>
    var taxPayables: FinancialMetric<Double>
    var deferredRevenue: FinancialMetric<Double>
    var otherCurrentLiabilities: FinancialMetric<Double>
    var totalCurrentLiabilities: FinancialMetric<Double>
    var longTermDebt: FinancialMetric<Double>
    var deferredRevenueNonCurrent: FinancialMetric<Double>
    var deferrredTaxLiabilitiesNonCurrent: FinancialMetric<Double>
    var otherNonCurrentLiabilities: FinancialMetric<Double>
    var totalNonCurrentLiabilities: FinancialMetric<Double>
    var otherLiabilities: FinancialMetric<Double>
    var totalLiabilities: FinancialMetric<Double>
    var commonStock: FinancialMetric<Double>
    var retainedEarnings: FinancialMetric<Double>
    var accumulatedOtherComprehensiveIncomeLoss: FinancialMetric<Double>
    var othertotalStockholdersEquity: FinancialMetric<Double>
    var totalStockholdersEquity: FinancialMetric<Double>
    var totalLiabilitiesAndStockholdersEquity: FinancialMetric<Double>
    var totalInvestments: FinancialMetric<Double>
    var totalDebt: FinancialMetric<Double>
    var netDebt: FinancialMetric<Double>
    
    var metrics: [FinancialMetric<Double>] {
        [cashAndCashEquivalents, shortTermInvestments, cashAndShortTermInvestments, netReceivables, inventory, otherCurrentAssets, totalCurrentAssets, propertyPlantEquipmentNet, goodwill, intangibleAssets, goodwillAndIntangibleAssets, longTermInvestments, taxAssets, otherNonCurrentAssets, totalNonCurrentAssets, otherAssets, totalAssets, accountPayables, shortTermDebt, taxPayables, deferredRevenue, otherCurrentLiabilities, totalCurrentLiabilities, longTermDebt, deferredRevenueNonCurrent, deferrredTaxLiabilitiesNonCurrent, otherNonCurrentLiabilities, totalNonCurrentLiabilities, otherLiabilities, totalLiabilities, commonStock, retainedEarnings, accumulatedOtherComprehensiveIncomeLoss, othertotalStockholdersEquity, totalStockholdersEquity, totalLiabilitiesAndStockholdersEquity, totalInvestments, totalDebt, netDebt]
    }
    
    static func stockIdentifier(_ ticker: String) -> String {
        return "balance sheet \(ticker)"
    }
}
