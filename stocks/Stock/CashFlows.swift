//
//  CashFlows.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct CashFlowFinancialMetric: Codable, Metric {
    var stringValue: String
    let doubleValue: Double
    var metricType: AnyMetricType?

    init(from decoder: Decoder) throws {
        doubleValue = try decoder.singleValueContainer().decode(Double?.self) ?? 0
        if decoder.codingPath.count > 1 {
            metricType = AnyMetricType(CashFlowMetricType(rawValue: decoder.codingPath[1].stringValue)!)
        }
        stringValue = ""
        stringValue = "\(doubleValue)".twoDigits.roundedWithAbbreviations.formatted(metricSuffixType)
    }
}

struct CashFlow: Codable, Financial {
    var date                                     : String
    var symbol                                   : String
    var period                                   : FiscalPeriod
    var netIncome                                : CashFlowFinancialMetric?
    var depreciationAndAmortization              : CashFlowFinancialMetric?
    var deferredIncomeTax                        : CashFlowFinancialMetric?
    var stockBasedCompensation                   : CashFlowFinancialMetric?
    var changeInWorkingCapital                   : CashFlowFinancialMetric?
    var accountsReceivables                      : CashFlowFinancialMetric?
    var inventory                                : CashFlowFinancialMetric?
    var accountsPayables                         : CashFlowFinancialMetric?
    var otherWorkingCapital                      : CashFlowFinancialMetric?
    var otherNonCashItems                        : CashFlowFinancialMetric?
    var netCashProvidedByOperatingActivities     : CashFlowFinancialMetric?
    var investmentsInPropertyPlantAndEquipment   : CashFlowFinancialMetric?
    var acquisitionsNet                          : CashFlowFinancialMetric?
    var purchasesOfInvestments                   : CashFlowFinancialMetric?
    var salesMaturitiesOfInvestments             : CashFlowFinancialMetric?
    var otherInvestingActivites                  : CashFlowFinancialMetric?
    var netCashUsedForInvestingActivites         : CashFlowFinancialMetric?
    var debtRepayment                            : CashFlowFinancialMetric?
    var commonStockIssued                        : CashFlowFinancialMetric?
    var commonStockRepurchased                   : CashFlowFinancialMetric?
    var dividendsPaid                            : CashFlowFinancialMetric?
    var otherFinancingActivites                  : CashFlowFinancialMetric?
    var netCashUsedProvidedByFinancingActivities : CashFlowFinancialMetric?
    var effectOfForexChangesOnCash               : CashFlowFinancialMetric?
    var netChangeInCash                          : CashFlowFinancialMetric?
    var cashAtEndOfPeriod                        : CashFlowFinancialMetric?
    var cashAtBeginningOfPeriod                  : CashFlowFinancialMetric?
    var operatingCashFlow                        : CashFlowFinancialMetric?
    var capitalExpenditure                       : CashFlowFinancialMetric?
    var freeCashFlow                             : CashFlowFinancialMetric?
    var link                                     : String?

    var metrics: [AnyMetric] {
        let arr: NSMutableArray = []
        
        if let netIncome                                = netIncome { arr.add(AnyMetric(netIncome)) }
        if let depreciationAndAmortization              = depreciationAndAmortization { arr.add(AnyMetric(depreciationAndAmortization)) }
        if let deferredIncomeTax                        = deferredIncomeTax { arr.add(AnyMetric(deferredIncomeTax)) }
        if let stockBasedCompensation                   = stockBasedCompensation { arr.add(AnyMetric(stockBasedCompensation)) }
        if let changeInWorkingCapital                   = changeInWorkingCapital { arr.add(AnyMetric(changeInWorkingCapital)) }
        if let accountsReceivables                      = accountsReceivables { arr.add(AnyMetric(accountsReceivables)) }
        if let inventory                                = inventory { arr.add(AnyMetric(inventory)) }
        if let accountsPayables                         = accountsPayables { arr.add(AnyMetric(accountsPayables)) }
        if let otherWorkingCapital                      = otherWorkingCapital { arr.add(AnyMetric(otherWorkingCapital)) }
        if let otherNonCashItems                        = otherNonCashItems { arr.add(AnyMetric(otherNonCashItems)) }
        if let netCashProvidedByOperatingActivities     = netCashProvidedByOperatingActivities { arr.add(AnyMetric(netCashProvidedByOperatingActivities)) }
        if let investmentsInPropertyPlantAndEquipment   = investmentsInPropertyPlantAndEquipment { arr.add(AnyMetric(investmentsInPropertyPlantAndEquipment)) }
        if let acquisitionsNet                          = acquisitionsNet { arr.add(AnyMetric(acquisitionsNet)) }
        if let purchasesOfInvestments                   = purchasesOfInvestments { arr.add(AnyMetric(purchasesOfInvestments)) }
        if let salesMaturitiesOfInvestments             = salesMaturitiesOfInvestments { arr.add(AnyMetric(salesMaturitiesOfInvestments)) }
        if let otherInvestingActivites                  = otherInvestingActivites { arr.add(AnyMetric(otherInvestingActivites)) }
        if let netCashUsedForInvestingActivites         = netCashUsedForInvestingActivites { arr.add(AnyMetric(netCashUsedForInvestingActivites)) }
        if let debtRepayment                            = debtRepayment { arr.add(AnyMetric(debtRepayment)) }
        if let commonStockIssued                        = commonStockIssued { arr.add(AnyMetric(commonStockIssued)) }
        if let commonStockRepurchased                   = commonStockRepurchased { arr.add(AnyMetric(commonStockRepurchased)) }
        if let dividendsPaid                            = dividendsPaid { arr.add(AnyMetric(dividendsPaid)) }
        if let otherFinancingActivites                  = otherFinancingActivites { arr.add(AnyMetric(otherFinancingActivites)) }
        if let netCashUsedProvidedByFinancingActivities = netCashUsedProvidedByFinancingActivities { arr.add(AnyMetric(netCashUsedProvidedByFinancingActivities)) }
        if let effectOfForexChangesOnCash               = effectOfForexChangesOnCash { arr.add(AnyMetric(effectOfForexChangesOnCash)) }
        if let netChangeInCash                          = netChangeInCash { arr.add(AnyMetric(netChangeInCash)) }
        if let cashAtEndOfPeriod                        = cashAtEndOfPeriod { arr.add(AnyMetric(cashAtEndOfPeriod)) }
        if let cashAtBeginningOfPeriod                  = cashAtBeginningOfPeriod { arr.add(AnyMetric(cashAtBeginningOfPeriod)) }
        if let operatingCashFlow                        = operatingCashFlow { arr.add(AnyMetric(operatingCashFlow)) }
        if let capitalExpenditure                       = capitalExpenditure { arr.add(AnyMetric(capitalExpenditure)) }
        if let freeCashFlow                             = freeCashFlow { arr.add(AnyMetric(freeCashFlow)) }
        
        return arr as? [AnyMetric] ?? []
    }
}

enum CashFlowMetricType: String, Codable, MetricType, CaseIterable {
    case date                                     = "date"
    case symbol                                   = "symbol"
    case period                                   = "period"
    case netIncome                                = "netIncome"
    case depreciationAndAmortization              = "depreciationAndAmortization"
    case deferredIncomeTax                        = "deferredIncomeTax"
    case stockBasedCompensation                   = "stockBasedCompensation"
    case changeInWorkingCapital                   = "changeInWorkingCapital"
    case accountsReceivables                      = "accountsReceivables"
    case inventory                                = "inventory"
    case accountsPayables                         = "accountsPayables"
    case otherWorkingCapital                      = "otherWorkingCapital"
    case otherNonCashItems                        = "otherNonCashItems"
    case netCashProvidedByOperatingActivities     = "netCashProvidedByOperatingActivities"
    case investmentsInPropertyPlantAndEquipment   = "investmentsInPropertyPlantAndEquipment"
    case acquisitionsNet                          = "acquisitionsNet"
    case purchasesOfInvestments                   = "purchasesOfInvestments"
    case salesMaturitiesOfInvestments             = "salesMaturitiesOfInvestments"
    case otherInvestingActivites                  = "otherInvestingActivites"
    case netCashUsedForInvestingActivites         = "netCashUsedForInvestingActivites"
    case debtRepayment                            = "debtRepayment"
    case commonStockIssued                        = "commonStockIssued"
    case commonStockRepurchased                   = "commonStockRepurchased"
    case dividendsPaid                            = "dividendsPaid"
    case otherFinancingActivites                  = "otherFinancingActivites"
    case netCashUsedProvidedByFinancingActivities = "netCashUsedProvidedByFinancingActivities"
    case effectOfForexChangesOnCash               = "effectOfForexChangesOnCash"
    case netChangeInCash                          = "netChangeInCash"
    case cashAtEndOfPeriod                        = "cashAtEndOfPeriod"
    case cashAtBeginningOfPeriod                  = "cashAtBeginningOfPeriod"
    case operatingCashFlow                        = "operatingCashFlow"
    case capitalExpenditure                       = "capitalExpenditure"
    case freeCashFlow                             = "freeCashFlow"
    case link                                     = "Latest balance sheet"
    
    var text: String {
        switch self {
        case .date                                     : return "Date"
        case .symbol                                   : return "Symbol"
        case .period                                   : return "Period"
        case .netIncome                                : return "Net income"
        case .depreciationAndAmortization              : return "Depreciation & amortization"
        case .deferredIncomeTax                        : return "Deferred income tax"
        case .stockBasedCompensation                   : return "Stock based compensation"
        case .changeInWorkingCapital                   : return "Change in working capital"
        case .accountsReceivables                      : return "Accounts receivables"
        case .inventory                                : return "Inventory"
        case .accountsPayables                         : return "Accounts payables"
        case .otherWorkingCapital                      : return "Other working capital"
        case .otherNonCashItems                        : return "Other non cash items"
        case .netCashProvidedByOperatingActivities     : return "Net cash provided by operating activities"
        case .investmentsInPropertyPlantAndEquipment   : return "Investments in property plant & equipment"
        case .acquisitionsNet                          : return "Acquisitions net"
        case .purchasesOfInvestments                   : return "Purchases of investments"
        case .salesMaturitiesOfInvestments             : return "Sales maturities of investments"
        case .otherInvestingActivites                  : return "Other investing activites"
        case .netCashUsedForInvestingActivites         : return "Net cash used for investing activites"
        case .debtRepayment                            : return "Debt repayment"
        case .commonStockIssued                        : return "Common stock issued"
        case .commonStockRepurchased                   : return "Common stock repurchased"
        case .dividendsPaid                            : return "Dividends paid"
        case .otherFinancingActivites                  : return "Other financing activites"
        case .netCashUsedProvidedByFinancingActivities : return "Net cash used provided by financing activities"
        case .effectOfForexChangesOnCash               : return "Effect of forex changes on cash"
        case .netChangeInCash                          : return "Net change in cash"
        case .cashAtEndOfPeriod                        : return "Cash at end of period"
        case .cashAtBeginningOfPeriod                  : return "Cash at beginning of period"
        case .operatingCashFlow                        : return "Operating cash flow"
        case .capitalExpenditure                       : return "Capital expenditure"
        case .freeCashFlow                             : return "Free cash flow"
        case .link                                     : return "Latest balance sheet"
        }
    }
    
    var suffixType: MetricSuffixType {
        return .money
    }
    
    var filterType: MetricFilterType {
        switch self {
        case .date, .symbol, .period, .link: return .none
        default: return .percentageGrowth
        }
    }
}
