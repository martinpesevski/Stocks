//
//  IncomeStatement.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

protocol Metric {
    var text: String { get }
    var value: String { get }
}

struct IncomeStatementsArray: Codable {
    var symbol: String
    var financials: [IncomeStatement]?

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
                let percentage = previousValue == 0 ? 0 : (-(previousValue - value)/previousValue) * 100
                previousValue = value
                mapped.append(percentage)
            }
        }

        return mapped.reversed()
    }
}

struct IncomeStatementFinancialMetric: Codable, Metric {
    var value: String
    var metricType: IncomeStatementMetricType?

    var text: String { metricType?.text ?? "" }

    init(from decoder: Decoder) throws {
        value = "\(ExponentRemoverFormatter.shared.number(from: try decoder.singleValueContainer().decode(String.self)) ?? 0)"
        if decoder.codingPath.count > 2 {
            metricType = IncomeStatementMetricType(rawValue: decoder.codingPath[2].stringValue)
        }
    }
}

struct IncomeStatement: Codable {
    var date: String
    var revenue: IncomeStatementFinancialMetric
    var revenueGrowth: IncomeStatementFinancialMetric
    var costOfRevenue: IncomeStatementFinancialMetric
    var grossProfit: IncomeStatementFinancialMetric
    var rndExpenses: IncomeStatementFinancialMetric
    var sgnaExpense: IncomeStatementFinancialMetric
    var operatingExpense: IncomeStatementFinancialMetric
    var operatingIncome: IncomeStatementFinancialMetric
    var interestExpense: IncomeStatementFinancialMetric
    var earningsBeforeTax: IncomeStatementFinancialMetric
    var incomeTaxExpense: IncomeStatementFinancialMetric
    var netIncomeNonInterest: IncomeStatementFinancialMetric
    var netIncomeDiscontinuedOps: IncomeStatementFinancialMetric
    var netIncome: IncomeStatementFinancialMetric
    var preferredDividends: IncomeStatementFinancialMetric
    var netIncomeComonStock: IncomeStatementFinancialMetric
    var eps: IncomeStatementFinancialMetric
    var epsDiluted: IncomeStatementFinancialMetric
    var weightedAvgSharesOut: IncomeStatementFinancialMetric
    var weightedAvgSharesOutDil: IncomeStatementFinancialMetric
    var dividendPerShare: IncomeStatementFinancialMetric
    var grossMargin: IncomeStatementFinancialMetric
    var ebitdaMargin: IncomeStatementFinancialMetric
    var ebitMargin: IncomeStatementFinancialMetric
    var profitMargin: IncomeStatementFinancialMetric
    var freeCashFlowMargin: IncomeStatementFinancialMetric
    var ebitda: IncomeStatementFinancialMetric
    var ebit: IncomeStatementFinancialMetric
    var consolidatedIncome: IncomeStatementFinancialMetric
    var earningsBeforeTaxMargin: IncomeStatementFinancialMetric
    var netProfitMargin: IncomeStatementFinancialMetric
    
    var metrics: [IncomeStatementFinancialMetric] {
        [revenue, revenueGrowth, costOfRevenue, grossProfit, rndExpenses, sgnaExpense, operatingExpense, operatingIncome, interestExpense, earningsBeforeTax, incomeTaxExpense, netIncomeNonInterest, netIncomeDiscontinuedOps, netIncome, preferredDividends, netIncomeComonStock, eps, epsDiluted, weightedAvgSharesOut, weightedAvgSharesOutDil, dividendPerShare, grossMargin, ebitdaMargin, ebitMargin, profitMargin, freeCashFlowMargin, ebitda, ebit, consolidatedIncome, earningsBeforeTaxMargin, netProfitMargin]
    }
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case revenue = "Revenue"
        case revenueGrowth = "Revenue Growth"
        case costOfRevenue = "Cost of Revenue"
        case grossProfit = "Gross Profit"
        case rndExpenses = "R&D Expenses"
        case sgnaExpense = "SG&A Expense"
        case operatingExpense = "Operating Expenses"
        case operatingIncome = "Operating Income"
        case interestExpense = "Interest Expense"
        case earningsBeforeTax = "Earnings before Tax"
        case incomeTaxExpense = "Income Tax Expense"
        case netIncomeNonInterest = "Net Income - Non-Controlling int"
        case netIncomeDiscontinuedOps = "Net Income - Discontinued ops"
        case netIncome = "Net Income"
        case preferredDividends = "Preferred Dividends"
        case netIncomeComonStock = "Net Income Com"
        case eps = "EPS"
        case epsDiluted = "EPS Diluted"
        case weightedAvgSharesOut = "Weighted Average Shs Out"
        case weightedAvgSharesOutDil = "Weighted Average Shs Out (Dil)"
        case dividendPerShare = "Dividend per Share"
        case grossMargin = "Gross Margin"
        case ebitdaMargin = "EBITDA Margin"
        case ebitMargin = "EBIT Margin"
        case profitMargin = "Profit Margin"
        case freeCashFlowMargin = "Free Cash Flow margin"
        case ebitda = "EBITDA"
        case ebit = "EBIT"
        case consolidatedIncome = "Consolidated Income"
        case earningsBeforeTaxMargin = "Earnings Before Tax Margin"
        case netProfitMargin = "Net Profit Margin"
    }
}

enum IncomeStatementMetricType: String, Codable {
    case date = "date"
    case revenue = "Revenue"
    case revenueGrowth = "Revenue Growth"
    case costOfRevenue = "Cost of Revenue"
    case grossProfit = "Gross Profit"
    case rndExpenses = "R&D Expenses"
    case sgnaExpense = "SG&A Expense"
    case operatingExpense = "Operating Expenses"
    case operatingIncome = "Operating Income"
    case interestExpense = "Interest Expense"
    case earningsBeforeTax = "Earnings before Tax"
    case incomeTaxExpense = "Income Tax Expense"
    case netIncomeNonInterest = "Net Income - Non-Controlling int"
    case netIncomeDiscontinuedOps = "Net Income - Discontinued ops"
    case netIncome = "Net Income"
    case preferredDividends = "Preferred Dividends"
    case netIncomeComonStock = "Net Income Com"
    case eps = "EPS"
    case epsDiluted = "EPS Diluted"
    case weightedAvgSharesOut = "Weighted Average Shs Out"
    case weightedAvgSharesOutDil = "Weighted Average Shs Out (Dil)"
    case dividendPerShare = "Dividend per Share"
    case grossMargin = "Gross Margin"
    case ebitdaMargin = "EBITDA Margin"
    case ebitMargin = "EBIT Margin"
    case profitMargin = "Profit Margin"
    case freeCashFlowMargin = "Free Cash Flow margin"
    case ebitda = "EBITDA"
    case ebit = "EBIT"
    case consolidatedIncome = "Consolidated Income"
    case earningsBeforeTaxMargin = "Earnings Before Tax Margin"
    case netProfitMargin = "Net Profit Margin"
    
    var text: String {
        switch self {
        case .date: return "Date"
        case .revenue: return "Revenue"
        case .revenueGrowth: return "Revenue growth"
        case .costOfRevenue: return "Cost of revenue"
        case .grossProfit: return "Gross profit"
        case .rndExpenses: return "R&D expenses"
        case .sgnaExpense: return "Selling, general and administrative expense"
        case .operatingExpense: return "Operating expense"
        case .operatingIncome: return "Operating income"
        case .interestExpense: return "Interest expense"
        case .earningsBeforeTax: return "Earnings before tax"
        case .incomeTaxExpense: return "Income tax expense"
        case .netIncomeNonInterest: return "Net income - non-controlling interest"
        case .netIncomeDiscontinuedOps: return "Net income - discontinued operations"
        case .netIncome: return "Net income"
        case .preferredDividends: return "Preferred dividends"
        case .netIncomeComonStock: return "Net income from common stock"
        case .eps: return "Earnings per share"
        case .epsDiluted: return "Earnings per share - diluted"
        case .weightedAvgSharesOut: return "Weighted average shares outstanding"
        case .weightedAvgSharesOutDil: return "Weighted average shares outstanding - diluted"
        case .dividendPerShare: return "Dividend per share"
        case .grossMargin: return "Gross margin"
        case .ebitdaMargin: return "EBITDA margin"
        case .ebitMargin: return "EBIT margin"
        case .profitMargin: return "Profit Margin"
        case .freeCashFlowMargin: return "Free cash flow margin"
        case .ebitda: return "EBITDA"
        case .ebit: return "EBIT"
        case .consolidatedIncome: return "Consolidated income"
        case .earningsBeforeTaxMargin: return "Earnings before tax margin"
        case .netProfitMargin: return "Net profit margin"
        }
    }
}
