//
//  CashFlows.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct CashFlowsArray: Codable {
    var symbol: String
    var financials: [CashFlow]?
}

struct CashFlowFinancialMetric<T: Codable>: Codable {
    let value: T
    var metricType: CashFlowMetricType?

    init(from decoder: Decoder) throws {
        value = try decoder.singleValueContainer().decode(T.self)
        if decoder.codingPath.count > 2 {
            metricType = CashFlowMetricType(rawValue: decoder.codingPath[2].stringValue)
        }
    }
}

struct CashFlow: Codable {
    var date: String
    var depreciationAmortization: CashFlowFinancialMetric<String>
    var stockBasedCompensation: CashFlowFinancialMetric<String>
    var operatincCashFlow: CashFlowFinancialMetric<String>
    var capitalExpenditure: CashFlowFinancialMetric<String>
    var acquisitionsDisposals: CashFlowFinancialMetric<String>
    var investmentPurchasesSales: CashFlowFinancialMetric<String>
    var investingCashFlow: CashFlowFinancialMetric<String>
    var issuanceRepaymentOfDebt: CashFlowFinancialMetric<String>
    var issuanceBuybackOfShares: CashFlowFinancialMetric<String>
    var dividentPayments: CashFlowFinancialMetric<String>
    var financingCashFlow: CashFlowFinancialMetric<String>
    var efectOfForex: CashFlowFinancialMetric<String>
    var netCashFlow: CashFlowFinancialMetric<String>
    var freeCashFlow: CashFlowFinancialMetric<String>
    var netCashOverMarketCap: CashFlowFinancialMetric<String>

    var metrics: [CashFlowFinancialMetric<String>] {
        [depreciationAmortization, stockBasedCompensation, operatincCashFlow, capitalExpenditure, acquisitionsDisposals, investmentPurchasesSales, investingCashFlow, issuanceRepaymentOfDebt, issuanceBuybackOfShares, dividentPayments, financingCashFlow, efectOfForex, netCashFlow, freeCashFlow, netCashOverMarketCap]
    }

    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case depreciationAmortization = "Depreciation & Amortization"
        case stockBasedCompensation = "Stock-based compensation"
        case operatincCashFlow = "Operating Cash Flow"
        case capitalExpenditure = "Capital Expenditure"
        case acquisitionsDisposals = "Acquisitions and disposals"
        case investmentPurchasesSales = "Investment purchases and sales"
        case investingCashFlow = "Investing Cash flow"
        case issuanceRepaymentOfDebt = "Issuance (repayment) of debt"
        case issuanceBuybackOfShares = "Issuance (buybacks) of shares"
        case dividentPayments = "Dividend payments"
        case financingCashFlow = "Financing Cash Flow"
        case efectOfForex = "Effect of forex changes on cash"
        case netCashFlow = "Net cash flow / Change in cash"
        case freeCashFlow = "Free Cash Flow"
        case netCashOverMarketCap = "Net Cash/Marketcap"
    }
}

enum CashFlowMetricType: String, Codable {
    case depreciationAmortization = "Depreciation & Amortization"
    case stockBasedCompensation = "Stock-based compensation"
    case operatincCashFlow = "Operating Cash Flow"
    case capitalExpenditure = "Capital Expenditure"
    case acquisitionsDisposals = "Acquisitions and disposals"
    case investmentPurchasesSales = "Investment purchases and sales"
    case investingCashFlow = "Investing Cash flow"
    case issuanceRepaymentOfDebt = "Issuance (repayment) of debt"
    case issuanceBuybackOfShares = "Issuance (buybacks) of shares"
    case dividentPayments = "Dividend payments"
    case financingCashFlow = "Financing Cash Flow"
    case efectOfForex = "Effect of forex changes on cash"
    case netCashFlow = "Net cash flow / Change in cash"
    case freeCashFlow = "Free Cash Flow"
    case netCashOverMarketCap = "Net Cash/Marketcap"

    var text: String {
        return rawValue
    }
}
