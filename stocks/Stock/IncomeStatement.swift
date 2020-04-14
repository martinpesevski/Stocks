//
//  IncomeStatement.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct IncomeStatementsArray: Codable {
    var symbol: String
    var financials: [IncomeStatement]?
}

struct IncomeStatementFinancialMetric<T: Codable>: Codable {
    let value: T
    var metricType: IncomeStatementMetricType?
    
    init(from decoder: Decoder) throws {
        value = try decoder.singleValueContainer().decode(T.self)
        if decoder.codingPath.count > 2 {
            metricType = IncomeStatementMetricType(rawValue: decoder.codingPath[2].stringValue)
        }
    }
}

struct IncomeStatement: Codable {
    var date: String
    var revenue: IncomeStatementFinancialMetric<String>
    var revenueGrowth: IncomeStatementFinancialMetric<String>
    var costOfRevenue: IncomeStatementFinancialMetric<String>
    var grossProfit: IncomeStatementFinancialMetric<String>
    var rndExpenses: IncomeStatementFinancialMetric<String>
    var sgnaExpense: IncomeStatementFinancialMetric<String>
    var operatingExpense: IncomeStatementFinancialMetric<String>
    var operatingIncome: IncomeStatementFinancialMetric<String>
    var interestExpense: IncomeStatementFinancialMetric<String>
    var earningsBeforeTax: IncomeStatementFinancialMetric<String>
    var incomeTaxExpense: IncomeStatementFinancialMetric<String>
    var netIncomeNonInterest: IncomeStatementFinancialMetric<String>
    var netIncomeDiscontinuedOps: IncomeStatementFinancialMetric<String>
    var netIncome: IncomeStatementFinancialMetric<String>
    var preferredDividends: IncomeStatementFinancialMetric<String>
    var netIncomeComonStock: IncomeStatementFinancialMetric<String>
    var eps: IncomeStatementFinancialMetric<String>
    var epsDiluted: IncomeStatementFinancialMetric<String>
    var weightedAvgSharesOut: IncomeStatementFinancialMetric<String>
    var weightedAvgSharesOutDil: IncomeStatementFinancialMetric<String>
    var dividendPerShare: IncomeStatementFinancialMetric<String>
    var grossMargin: IncomeStatementFinancialMetric<String>
    var ebitdaMargin: IncomeStatementFinancialMetric<String>
    var ebitMargin: IncomeStatementFinancialMetric<String>
    var profitMargin: IncomeStatementFinancialMetric<String>
    var freeCashFlowMargin: IncomeStatementFinancialMetric<String>
    var ebitda: IncomeStatementFinancialMetric<String>
    var ebit: IncomeStatementFinancialMetric<String>
    var consolidatedIncome: IncomeStatementFinancialMetric<String>
    var earningsBeforeTaxMargin: IncomeStatementFinancialMetric<String>
    var netProfitMargin: IncomeStatementFinancialMetric<String>
    
    var metrics: [IncomeStatementFinancialMetric<String>] {
        [revenue, revenueGrowth, costOfRevenue, grossProfit, rndExpenses, sgnaExpense, operatingExpense, operatingIncome, interestExpense, earningsBeforeTax, incomeTaxExpense, netIncomeNonInterest, netIncomeDiscontinuedOps, netIncome, preferredDividends, netIncomeComonStock, eps, epsDiluted, weightedAvgSharesOut, weightedAvgSharesOutDil, dividendPerShare, grossMargin, ebitdaMargin, ebitMargin, profitMargin, freeCashFlowMargin, ebitda, ebit, consolidatedIncome, earningsBeforeTaxMargin, netProfitMargin]
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(String.self, forKey: .date)
        revenue = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .revenue)
        revenueGrowth = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .revenueGrowth)
        costOfRevenue = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .costOfRevenue)
        grossProfit = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .grossProfit)
        rndExpenses = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .rndExpenses)
        sgnaExpense = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .sgnaExpense)
        operatingExpense = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .operatingExpense)
        operatingIncome = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .operatingIncome)
        interestExpense = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .interestExpense)
        earningsBeforeTax = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .earningsBeforeTax)
        incomeTaxExpense = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .incomeTaxExpense)
        netIncomeNonInterest = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .netIncomeNonInterest)
        netIncomeDiscontinuedOps = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .netIncomeDiscontinuedOps)
        netIncome = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .netIncome)
        preferredDividends = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .preferredDividends)
        netIncomeComonStock = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .netIncomeComonStock)
        eps = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .eps)
        epsDiluted = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .epsDiluted)
        weightedAvgSharesOut = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .weightedAvgSharesOut)
        weightedAvgSharesOutDil = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .weightedAvgSharesOutDil)
        dividendPerShare = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .dividendPerShare)
        grossMargin = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .grossMargin)
        ebitdaMargin = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .ebitdaMargin)
        ebitMargin = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .ebitMargin)
        profitMargin = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .profitMargin)
        freeCashFlowMargin = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .freeCashFlowMargin)
        ebitda = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .ebitda)
        ebit = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .ebit)
        consolidatedIncome = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .consolidatedIncome)
        earningsBeforeTaxMargin = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .earningsBeforeTaxMargin)
        netProfitMargin = try values.decode(IncomeStatementFinancialMetric<String>.self, forKey: .netProfitMargin)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(revenue, forKey: .revenue)
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
