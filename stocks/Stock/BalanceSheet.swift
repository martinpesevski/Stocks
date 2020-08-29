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

struct BalanceSheetFinancialMetric: Codable, Metric {
    let value: String
    var metricType: BalanceSheetMetricType?

    var text: String { metricType?.text ?? "" }

    init(from decoder: Decoder) throws {
        value = "\(ExponentRemoverFormatter.shared.number(from: try decoder.singleValueContainer().decode(String.self)) ?? 0)"
        if decoder.codingPath.count > 2 {
            metricType = BalanceSheetMetricType(rawValue: decoder.codingPath[2].stringValue)
        }
    }
}

enum BalanceSheetMetricType: String, Codable {
    case cashAndCashEquivalents = "Cash and cash equivalents"
    case shortTermInvestments = "Short-term investments"
    case cashAndShortTermInvestments = "Cash and short-term investments"
    case netReceivables = "Receivables"
    case inventory = "Inventories"
    case totalCurrentAssets = "Total current assets"
    case propertyPlantEquipmentNet = "Property, Plant & Equipment Net"
    case goodwillAndIntangibleAssets = "Goodwill and Intangible Assets"
    case longTermInvestments = "Long-term investments"
    case taxAssets = "Tax assets"
    case totalNonCurrentAssets = "Total non-current assets"
    case totalAssets = "Total assets"
    case accountPayables = "Payables"
    case shortTermDebt = "Short-term debt"
    case totalCurrentLiabilities = "Total current liabilities"
    case longTermDebt = "Long-term debt"
    case totalDebt = "Total debt"
    case deferredRevenue = "Deferred revenue"
    case taxLiabilities = "Tax Liabilities"
    case depositLiabilities = "Deposit Liabilities"
    case totalNonCurrentLiabilities = "Total non-current liabilities"
    case totalLiabilities = "Total liabilities"
    case otherComprehensiveIncome = "Other comprehensive income"
    case retainedEarnings = "Retained earnings (deficit)"
    case totalStockholdersEquity = "Total shareholders equity"
    case totalInvestments = "Investments"
    case netDebt = "Net Debt"
    case otherAssets = "Other Assets"
    case otherLiabilities = "Other Liabilities"
    
    var text: String {
       return rawValue
    }
}

struct BalanceSheetArray: Codable {
    var symbol: String
    var financials: [BalanceSheet]?

    func latestValue(metric: Metric) -> String {
        guard let financial = financials?.sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        }).first else { return "" }
        
        for mtc in financial.metrics where mtc.metricType?.text == metric.text {
            return mtc.value
        }
        
        return ""
    }
    
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

struct BalanceSheet: Codable {
    var date: String
    var cashAndCashEquivalents: BalanceSheetFinancialMetric
    var shortTermInvestments: BalanceSheetFinancialMetric
    var cashAndShortTermInvestments: BalanceSheetFinancialMetric
    var netReceivables: BalanceSheetFinancialMetric
    var inventory: BalanceSheetFinancialMetric
    var totalCurrentAssets: BalanceSheetFinancialMetric
    var propertyPlantEquipmentNet: BalanceSheetFinancialMetric
    var goodwillAndIntangibleAssets: BalanceSheetFinancialMetric
    var longTermInvestments: BalanceSheetFinancialMetric
    var taxAssets: BalanceSheetFinancialMetric
    var totalNonCurrentAssets: BalanceSheetFinancialMetric
    var totalAssets: BalanceSheetFinancialMetric
    var accountPayables: BalanceSheetFinancialMetric
    var shortTermDebt: BalanceSheetFinancialMetric
    var totalCurrentLiabilities: BalanceSheetFinancialMetric
    var longTermDebt: BalanceSheetFinancialMetric
    var totalDebt: BalanceSheetFinancialMetric
    var deferredRevenue: BalanceSheetFinancialMetric
    var taxLiabilities: BalanceSheetFinancialMetric
    var depositLiabilities: BalanceSheetFinancialMetric
    var totalNonCurrentLiabilities: BalanceSheetFinancialMetric
    var totalLiabilities: BalanceSheetFinancialMetric
    var otherComprehensiveIncome: BalanceSheetFinancialMetric
    var retainedEarnings: BalanceSheetFinancialMetric
    var totalStockholdersEquity: BalanceSheetFinancialMetric
    var totalInvestments: BalanceSheetFinancialMetric
    var netDebt: BalanceSheetFinancialMetric
    var otherAssets: BalanceSheetFinancialMetric
    var otherLiabilities: BalanceSheetFinancialMetric
    
    var metrics: [BalanceSheetFinancialMetric] {
        [cashAndCashEquivalents, shortTermInvestments, cashAndShortTermInvestments, netReceivables, inventory, totalCurrentAssets, propertyPlantEquipmentNet, goodwillAndIntangibleAssets, longTermInvestments, taxAssets, totalNonCurrentAssets, totalAssets, accountPayables, shortTermDebt, totalCurrentLiabilities, longTermDebt, deferredRevenue, taxLiabilities, depositLiabilities, totalNonCurrentLiabilities, totalLiabilities, otherComprehensiveIncome, retainedEarnings, totalStockholdersEquity, totalInvestments, netDebt, otherAssets, otherLiabilities]
    }

    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case cashAndCashEquivalents = "Cash and cash equivalents"
        case shortTermInvestments = "Short-term investments"
        case cashAndShortTermInvestments = "Cash and short-term investments"
        case netReceivables = "Receivables"
        case inventory = "Inventories"
        case totalCurrentAssets = "Total current assets"
        case propertyPlantEquipmentNet = "Property, Plant & Equipment Net"
        case goodwillAndIntangibleAssets = "Goodwill and Intangible Assets"
        case longTermInvestments = "Long-term investments"
        case taxAssets = "Tax assets"
        case totalNonCurrentAssets = "Total non-current assets"
        case totalAssets = "Total assets"
        case accountPayables = "Payables"
        case shortTermDebt = "Short-term debt"
        case totalCurrentLiabilities = "Total current liabilities"
        case longTermDebt = "Long-term debt"
        case totalDebt = "Total debt"
        case deferredRevenue = "Deferred revenue"
        case taxLiabilities = "Tax Liabilities"
        case depositLiabilities = "Deposit Liabilities"
        case totalNonCurrentLiabilities = "Total non-current liabilities"
        case totalLiabilities = "Total liabilities"
        case otherComprehensiveIncome = "Other comprehensive income"
        case retainedEarnings = "Retained earnings (deficit)"
        case totalStockholdersEquity = "Total shareholders equity"
        case totalInvestments = "Investments"
        case netDebt = "Net Debt"
        case otherAssets = "Other Assets"
        case otherLiabilities = "Other Liabilities"
    }
}
