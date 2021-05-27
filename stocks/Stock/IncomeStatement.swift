//
//  IncomeStatement.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct IncomeStatementFinancialMetric: Codable, Metric {
    var stringValue: String
    var doubleValue: Double
    var metricType: AnyMetricType?

    init(from decoder: Decoder) throws {
        if decoder.codingPath.count > 1 {
            metricType = AnyMetricType(IncomeStatementMetricType(rawValue: decoder.codingPath[1].stringValue) ?? IncomeStatementMetricType.date)
        }
        doubleValue = try decoder.singleValueContainer().decode(Double?.self) ?? 0
        stringValue = ""
        stringValue = (metricSuffixType == .percentage ? "\(doubleValue * 100)".twoDigits : "\("\(doubleValue)".twoDigits.roundedWithAbbreviations)").formatted(metricSuffixType)
    }
}

struct IncomeStatement: Codable, Financial {
    var date                             : String
    var symbol                           : String
    var period                           : FiscalPeriod
    var revenue                          : IncomeStatementFinancialMetric
    var costOfRevenue                    : IncomeStatementFinancialMetric
    var grossProfit                      : IncomeStatementFinancialMetric
    var grossProfitRatio                 : IncomeStatementFinancialMetric
    var researchAndDevelopmentExpenses   : IncomeStatementFinancialMetric
    var generalAndAdministrativeExpenses : IncomeStatementFinancialMetric
    var sellingAndMarketingExpenses      : IncomeStatementFinancialMetric
    var otherExpenses                    : IncomeStatementFinancialMetric
    var operatingExpenses                : IncomeStatementFinancialMetric
    var costAndExpenses                  : IncomeStatementFinancialMetric
    var interestExpense                  : IncomeStatementFinancialMetric
    var depreciationAndAmortization      : IncomeStatementFinancialMetric
    var ebitda                           : IncomeStatementFinancialMetric
    var ebitdaratio                      : IncomeStatementFinancialMetric
    var operatingIncome                  : IncomeStatementFinancialMetric
    var operatingIncomeRatio             : IncomeStatementFinancialMetric
    var totalOtherIncomeExpensesNet      : IncomeStatementFinancialMetric
    var incomeBeforeTax                  : IncomeStatementFinancialMetric
    var incomeBeforeTaxRatio             : IncomeStatementFinancialMetric
    var incomeTaxExpense                 : IncomeStatementFinancialMetric
    var netIncome                        : IncomeStatementFinancialMetric
    var netIncomeRatio                   : IncomeStatementFinancialMetric
    var eps                              : IncomeStatementFinancialMetric
    var epsdiluted                       : IncomeStatementFinancialMetric
    var weightedAverageShsOut            : IncomeStatementFinancialMetric
    var weightedAverageShsOutDil         : IncomeStatementFinancialMetric
    var link                             : String?
    
    var metrics: [AnyMetric] {
        [
         AnyMetric(revenue),
         AnyMetric(costOfRevenue),
         AnyMetric(grossProfit),
         AnyMetric(grossProfitRatio),
         AnyMetric(researchAndDevelopmentExpenses),
         AnyMetric(generalAndAdministrativeExpenses),
         AnyMetric(sellingAndMarketingExpenses),
         AnyMetric(otherExpenses),
         AnyMetric(operatingExpenses),
         AnyMetric(costAndExpenses),
         AnyMetric(interestExpense),
         AnyMetric(depreciationAndAmortization),
         AnyMetric(ebitda),
         AnyMetric(ebitdaratio),
         AnyMetric(operatingIncome),
         AnyMetric(operatingIncomeRatio),
         AnyMetric(totalOtherIncomeExpensesNet),
         AnyMetric(incomeBeforeTax),
         AnyMetric(incomeBeforeTaxRatio),
         AnyMetric(incomeTaxExpense),
         AnyMetric(netIncome),
         AnyMetric(netIncomeRatio),
         AnyMetric(eps),
         AnyMetric(epsdiluted),
         AnyMetric(weightedAverageShsOut),
         AnyMetric(weightedAverageShsOutDil)
        ]
    }
}

enum IncomeStatementMetricType: String, Codable, MetricType, CaseIterable {
    case date                             = "date"
    case symbol                           = "symbol"
    case period                           = "period"
    case revenue                          = "revenue"
    case costOfRevenue                    = "costOfRevenue"
    case grossProfit                      = "grossProfit"
    case grossProfitRatio                 = "grossProfitRatio"
    case researchAndDevelopmentExpenses   = "researchAndDevelopmentExpenses"
    case generalAndAdministrativeExpenses = "generalAndAdministrativeExpenses"
    case sellingAndMarketingExpenses      = "sellingAndMarketingExpenses"
    case otherExpenses                    = "otherExpenses"
    case operatingExpenses                = "operatingExpenses"
    case costAndExpenses                  = "costAndExpenses"
    case interestExpense                  = "interestExpense"
    case depreciationAndAmortization      = "depreciationAndAmortization"
    case ebitda                           = "ebitda"
    case ebitdaratio                      = "ebitdaratio"
    case operatingIncome                  = "operatingIncome"
    case operatingIncomeRatio             = "operatingIncomeRatio"
    case totalOtherIncomeExpensesNet      = "totalOtherIncomeExpensesNet"
    case incomeBeforeTax                  = "incomeBeforeTax"
    case incomeBeforeTaxRatio             = "incomeBeforeTaxRatio"
    case incomeTaxExpense                 = "incomeTaxExpense"
    case netIncome                        = "netIncome"
    case netIncomeRatio                   = "netIncomeRatio"
    case eps                              = "eps"
    case epsdiluted                       = "epsdiluted"
    case weightedAverageShsOut            = "weightedAverageShsOut"
    case weightedAverageShsOutDil         = "weightedAverageShsOutDil"
    case link                             = "link"
    
    var text: String {
        switch self {
        case .date                             : return "Date"
        case .symbol                           : return "Symbol"
        case .period                           : return "Period"
        case .revenue                          : return "Revenue"
        case .costOfRevenue                    : return "Cost of revenue"
        case .grossProfit                      : return "Gross profit"
        case .grossProfitRatio                 : return "Gross margin"
        case .researchAndDevelopmentExpenses   : return "R&D expenses"
        case .generalAndAdministrativeExpenses : return "General/Administrative expenses"
        case .sellingAndMarketingExpenses      : return "Selling/Marketing expenses"
        case .otherExpenses                    : return "Other expenses"
        case .operatingExpenses                : return "Operating expenses"
        case .costAndExpenses                  : return "Cost and expenses"
        case .interestExpense                  : return "Interest expense"
        case .depreciationAndAmortization      : return "Depreciation & amortization"
        case .ebitda                           : return "EBITDA"
        case .ebitdaratio                      : return "EBITDA margin"
        case .operatingIncome                  : return "Operating income"
        case .operatingIncomeRatio             : return "Operating margin"
        case .totalOtherIncomeExpensesNet      : return "Total other expenses"
        case .incomeBeforeTax                  : return "Earnings before tax"
        case .incomeBeforeTaxRatio             : return "Earnings before tax margin"
        case .incomeTaxExpense                 : return "Income tax expense"
        case .netIncome                        : return "Net income"
        case .netIncomeRatio                   : return "Net margin"
        case .eps                              : return "EPS"
        case .epsdiluted                       : return "EPS diluted"
        case .weightedAverageShsOut            : return "Weighted avg shs outstanding"
        case .weightedAverageShsOutDil         : return "Weighted avg shs outstanding diluted"
        case .link                             : return "Latest income statement"
        }
    }
    
    var suffixType: MetricSuffixType {
        switch self {
        case .operatingIncomeRatio, .incomeBeforeTaxRatio, .netIncomeRatio, .ebitdaratio, .grossProfitRatio: return .percentage
        case .weightedAverageShsOut, .weightedAverageShsOutDil, .date, .symbol, .link: return .none
        default: return .money
        }
    }
    
    var filterType: MetricFilterType {
        switch self {
        case .date, .symbol, .period, .link: return .none
        case .operatingIncomeRatio, .incomeBeforeTaxRatio, .netIncomeRatio, .ebitdaratio, .grossProfitRatio: return .metric
        default: return .percentageGrowth
        }
    }
}
