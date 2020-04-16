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

struct CashFlowFinancialMetric: Codable, Metric {
    let value: String
    var metricType: CashFlowMetricType?

    var text: String { metricType?.text ?? ""}

    init(from decoder: Decoder) throws {
        value = "\(ExponentRemoverFormatter.shared.number(from: try decoder.singleValueContainer().decode(String.self)) ?? 0)"
        if decoder.codingPath.count > 2 {
            metricType = CashFlowMetricType(rawValue: decoder.codingPath[2].stringValue)
        }
    }
}

struct CashFlow: Codable {
    var date: String
    var depreciationAmortization: CashFlowFinancialMetric
    var stockBasedCompensation: CashFlowFinancialMetric
    var operatincCashFlow: CashFlowFinancialMetric
    var capitalExpenditure: CashFlowFinancialMetric
    var acquisitionsDisposals: CashFlowFinancialMetric
    var investmentPurchasesSales: CashFlowFinancialMetric
    var investingCashFlow: CashFlowFinancialMetric
    var issuanceRepaymentOfDebt: CashFlowFinancialMetric
    var issuanceBuybackOfShares: CashFlowFinancialMetric
    var dividentPayments: CashFlowFinancialMetric
    var financingCashFlow: CashFlowFinancialMetric
    var efectOfForex: CashFlowFinancialMetric
    var netCashFlow: CashFlowFinancialMetric
    var freeCashFlow: CashFlowFinancialMetric
    var netCashOverMarketCap: CashFlowFinancialMetric

    var metrics: [CashFlowFinancialMetric] {
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
