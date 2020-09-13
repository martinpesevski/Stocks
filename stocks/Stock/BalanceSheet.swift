//
//  BalanceSheet.swift
//  stocks
//
//  Created by Martin Peshevski on 4/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct BalanceSheetFinancialMetric: Codable, Metric {
    var stringValue: String
    let doubleValue: Double
    var metricType: AnyMetricType?

    init(from decoder: Decoder) throws {
        doubleValue = try decoder.singleValueContainer().decode(Double?.self) ?? 0
        if decoder.codingPath.count > 1 {
            metricType = AnyMetricType(BalanceSheetMetricType(rawValue: decoder.codingPath[1].stringValue)!)
        }
        stringValue = ""
        stringValue = "\(doubleValue)".twoDigits.roundedWithAbbreviations.formatted(metricSuffixType)
    }
}

enum BalanceSheetMetricType: String, Codable, MetricType {
    case date                                    = "date"
    case symbol                                  = "symbol"
    case period                                  = "period"
    case cashAndCashEquivalents                  = "cashAndCashEquivalents"
    case shortTermInvestments                    = "shortTermInvestments"
    case cashAndShortTermInvestments             = "cashAndShortTermInvestments"
    case netReceivables                          = "netReceivables"
    case inventory                               = "inventory"
    case otherCurrentAssets                      = "otherCurrentAssets"
    case totalCurrentAssets                      = "totalCurrentAssets"
    case propertyPlantEquipmentNet               = "propertyPlantEquipmentNet"
    case goodwill                                = "goodwill"
    case intangibleAssets                        = "intangibleAssets"
    case goodwillAndIntangibleAssets             = "goodwillAndIntangibleAssets"
    case longTermInvestments                     = "longTermInvestments"
    case taxAssets                               = "taxAssets"
    case otherNonCurrentAssets                   = "otherNonCurrentAssets"
    case totalNonCurrentAssets                   = "totalNonCurrentAssets"
    case otherAssets                             = "otherAssets"
    case totalAssets                             = "totalAssets"
    case accountPayables                         = "accountPayables"
    case shortTermDebt                           = "shortTermDebt"
    case taxPayables                             = "taxPayables"
    case deferredRevenue                         = "deferredRevenue"
    case otherCurrentLiabilities                 = "otherCurrentLiabilities"
    case totalCurrentLiabilities                 = "totalCurrentLiabilities"
    case longTermDebt                            = "longTermDebt"
    case deferredRevenueNonCurrent               = "deferredRevenueNonCurrent"
    case deferredTaxLiabilitiesNonCurrent        = "deferredTaxLiabilitiesNonCurrent"
    case otherNonCurrentLiabilities              = "otherNonCurrentLiabilities"
    case totalNonCurrentLiabilities              = "totalNonCurrentLiabilities"
    case otherLiabilities                        = "otherLiabilities"
    case totalLiabilities                        = "totalLiabilities"
    case commonStock                             = "commonStock"
    case retainedEarnings                        = "retainedEarnings"
    case accumulatedOtherComprehensiveIncomeLoss = "accumulatedOtherComprehensiveIncomeLoss"
    case othertotalStockholdersEquity            = "othertotalStockholdersEquity"
    case totalStockholdersEquity                 = "totalStockholdersEquity"
    case totalLiabilitiesAndStockholdersEquity   = "totalLiabilitiesAndStockholdersEquity"
    case totalInvestments                        = "totalInvestments"
    case totalDebt                               = "totalDebt"
    case netDebt                                 = "netDebt"
    case link                                    = "link"

    var text: String {
        switch self {
        case .date                                    : return "Date"
        case .symbol                                  : return "Symbol"
        case .period                                  : return "Period"
        case .cashAndCashEquivalents                  : return "Cash and cash equivalents"
        case .shortTermInvestments                    : return "Short term investments"
        case .cashAndShortTermInvestments             : return "Cash & short term investments"
        case .netReceivables                          : return "Net receivables"
        case .inventory                               : return "Inventory"
        case .otherCurrentAssets                      : return "Other current assets"
        case .totalCurrentAssets                      : return "Total current assets"
        case .propertyPlantEquipmentNet               : return "Property/plant equipment net"
        case .goodwill                                : return "Goodwill"
        case .intangibleAssets                        : return "Intangible assets"
        case .goodwillAndIntangibleAssets             : return "Goodwill & intangible assets"
        case .longTermInvestments                     : return "Long term investments"
        case .taxAssets                               : return "Tax assets"
        case .otherNonCurrentAssets                   : return "Other non-current assets"
        case .totalNonCurrentAssets                   : return "Total non-current assets"
        case .otherAssets                             : return "Other assets"
        case .totalAssets                             : return "Total assets"
        case .accountPayables                         : return "Account payables"
        case .shortTermDebt                           : return "Short term debt"
        case .taxPayables                             : return "Tax payables"
        case .deferredRevenue                         : return "Deferred revenue"
        case .otherCurrentLiabilities                 : return "Other current liabilities"
        case .totalCurrentLiabilities                 : return "Total current liabilities"
        case .longTermDebt                            : return "Long term debt"
        case .deferredRevenueNonCurrent               : return "Deferred revenue non-current"
        case .deferredTaxLiabilitiesNonCurrent        : return "Deferred tax liabilities non-current"
        case .otherNonCurrentLiabilities              : return "Other non-current liabilities"
        case .totalNonCurrentLiabilities              : return "Total non-current liabilities"
        case .otherLiabilities                        : return "Other liabilities"
        case .totalLiabilities                        : return "Total liabilities"
        case .commonStock                             : return "Common stock"
        case .retainedEarnings                        : return "Retained earnings"
        case .accumulatedOtherComprehensiveIncomeLoss : return "Accumulated other comprehensive income/loss"
        case .othertotalStockholdersEquity            : return "Other total stockholders equity"
        case .totalStockholdersEquity                 : return "Total stockholders equity"
        case .totalLiabilitiesAndStockholdersEquity   : return "Total liabilities & stockholders equity"
        case .totalInvestments                        : return "Total investments"
        case .totalDebt                               : return "Total debt"
        case .netDebt                                 : return "Net debt"
        case .link                                    : return "Latest balance sheet"
        }
    }
    
    var suffixType: MetricSuffixType {
        return .money
    }
}

struct BalanceSheet: Codable, Financial {
    var date                                    : String
    var symbol                                  : String
    var period                                  : FiscalPeriod
    var cashAndCashEquivalents                  : BalanceSheetFinancialMetric
    var shortTermInvestments                    : BalanceSheetFinancialMetric
    var cashAndShortTermInvestments             : BalanceSheetFinancialMetric
    var netReceivables                          : BalanceSheetFinancialMetric
    var inventory                               : BalanceSheetFinancialMetric
    var otherCurrentAssets                      : BalanceSheetFinancialMetric
    var totalCurrentAssets                      : BalanceSheetFinancialMetric
    var propertyPlantEquipmentNet               : BalanceSheetFinancialMetric
    var goodwill                                : BalanceSheetFinancialMetric
    var intangibleAssets                        : BalanceSheetFinancialMetric
    var goodwillAndIntangibleAssets             : BalanceSheetFinancialMetric
    var longTermInvestments                     : BalanceSheetFinancialMetric
    var taxAssets                               : BalanceSheetFinancialMetric
    var otherNonCurrentAssets                   : BalanceSheetFinancialMetric
    var totalNonCurrentAssets                   : BalanceSheetFinancialMetric
    var otherAssets                             : BalanceSheetFinancialMetric
    var totalAssets                             : BalanceSheetFinancialMetric
    var accountPayables                         : BalanceSheetFinancialMetric
    var shortTermDebt                           : BalanceSheetFinancialMetric
    var taxPayables                             : BalanceSheetFinancialMetric
    var deferredRevenue                         : BalanceSheetFinancialMetric
    var otherCurrentLiabilities                 : BalanceSheetFinancialMetric
    var totalCurrentLiabilities                 : BalanceSheetFinancialMetric
    var longTermDebt                            : BalanceSheetFinancialMetric
    var deferredRevenueNonCurrent               : BalanceSheetFinancialMetric
    var deferredTaxLiabilitiesNonCurrent        : BalanceSheetFinancialMetric
    var otherNonCurrentLiabilities              : BalanceSheetFinancialMetric
    var totalNonCurrentLiabilities              : BalanceSheetFinancialMetric
    var otherLiabilities                        : BalanceSheetFinancialMetric
    var totalLiabilities                        : BalanceSheetFinancialMetric
    var commonStock                             : BalanceSheetFinancialMetric
    var retainedEarnings                        : BalanceSheetFinancialMetric
    var accumulatedOtherComprehensiveIncomeLoss : BalanceSheetFinancialMetric
    var othertotalStockholdersEquity            : BalanceSheetFinancialMetric
    var totalStockholdersEquity                 : BalanceSheetFinancialMetric
    var totalLiabilitiesAndStockholdersEquity   : BalanceSheetFinancialMetric
    var totalInvestments                        : BalanceSheetFinancialMetric
    var totalDebt                               : BalanceSheetFinancialMetric
    var netDebt                                 : BalanceSheetFinancialMetric
    var link                                    : String?
    
    var metrics: [AnyMetric] {
        [
           AnyMetric(cashAndCashEquivalents),
           AnyMetric(shortTermInvestments),
           AnyMetric(cashAndShortTermInvestments),
           AnyMetric(netReceivables),
           AnyMetric(inventory),
           AnyMetric(otherCurrentAssets),
           AnyMetric(totalCurrentAssets),
           AnyMetric(propertyPlantEquipmentNet),
           AnyMetric(goodwill),
           AnyMetric(intangibleAssets),
           AnyMetric(goodwillAndIntangibleAssets),
           AnyMetric(longTermInvestments),
           AnyMetric(taxAssets),
           AnyMetric(otherNonCurrentAssets),
           AnyMetric(totalNonCurrentAssets),
           AnyMetric(otherAssets),
           AnyMetric(totalAssets),
           AnyMetric(accountPayables),
           AnyMetric(shortTermDebt),
           AnyMetric(taxPayables),
           AnyMetric(deferredRevenue),
           AnyMetric(otherCurrentLiabilities),
           AnyMetric(totalCurrentLiabilities),
           AnyMetric(longTermDebt),
           AnyMetric(deferredRevenueNonCurrent),
           AnyMetric(deferredTaxLiabilitiesNonCurrent),
           AnyMetric(otherNonCurrentLiabilities),
           AnyMetric(totalNonCurrentLiabilities),
           AnyMetric(otherLiabilities),
           AnyMetric(totalLiabilities),
           AnyMetric(commonStock),
           AnyMetric(retainedEarnings),
           AnyMetric(accumulatedOtherComprehensiveIncomeLoss),
           AnyMetric(othertotalStockholdersEquity),
           AnyMetric(totalStockholdersEquity),
           AnyMetric(totalLiabilitiesAndStockholdersEquity),
           AnyMetric(totalInvestments),
           AnyMetric(totalDebt),
           AnyMetric(netDebt)
        ]
    }
}
