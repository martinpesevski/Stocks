//
//  KeyMetrics.swift
//  stocks
//
//  Created by Martin Peshevski on 3/16/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element == KeyMetrics {
    var averageOCFGrowth: Double? {
        let ocfMetrics = compactMap { $0.ocf }.sorted { $0 < $1 }
        var total: Double = 0
        for (index, value) in ocfMetrics.enumerated() where index > 0 {
            total += (value - ocfMetrics[index - 1]) / value
        }
        return total / Double(ocfMetrics.count)
    }

    var projectedFutureGrowth: Double? {
        guard let averageOCFGrowth = averageOCFGrowth else { return nil }
        return Swift.min(averageOCFGrowth, 0.15)
    }

    var profitability: Profitability? {
        guard !isEmpty else { return nil }

        var netIncomeAverage: Double = 0
        let netIncomes = compactMap { $0.netIncomePerShare?.doubleValue }
        for value in netIncomes {
            netIncomeAverage += value
        }
        netIncomeAverage /= Double(netIncomes.count)

        return netIncomeAverage > 0 ? .profitable : .unprofitable
    }
}

struct KeyMetricsFinancialMetric: Codable, Metric {
    var stringValue: String
    let doubleValue: Double
    var metricType: AnyMetricType?

    init(from decoder: Decoder) throws {
        if let decoderValue = decoder.codingPath[safe: 1]?.stringValue,
            let decodedType = KeyMetricsMetricType(rawValue: decoderValue) {
            metricType = AnyMetricType(decodedType)
        }
        doubleValue = try decoder.singleValueContainer().decode(Double?.self) ?? 0
        stringValue = ""
        stringValue = (metricSuffixType == .percentage ? "\(doubleValue * 100)".twoDigits : "\("\(doubleValue)".twoDigits.roundedWithAbbreviations)").formatted(metricSuffixType)
    }
}

enum KeyMetricsMetricType: String, Codable, MetricType, CaseIterable {
    case symbol                                 = "symbol"
    case date                                   = "date"
    case revenuePerShare                        = "revenuePerShare"
    case netIncomePerShare                      = "netIncomePerShare"
    case operatingCashFlowPerShare              = "operatingCashFlowPerShare"
    case freeCashFlowPerShare                   = "freeCashFlowPerShare"
    case cashPerShare                           = "cashPerShare"
    case bookValuePerShare                      = "bookValuePerShare"
    case tangibleBookValuePerShare              = "tangibleBookValuePerShare"
    case shareholdersEquityPerShare             = "shareholdersEquityPerShare"
    case interestDebtPerShare                   = "interestDebtPerShare"
    case marketCap                              = "marketCap"
    case enterpriseValue                        = "enterpriseValue"
    case peRatio                                = "peRatio"
    case priceToSalesRatio                      = "priceToSalesRatio"
    case pocfratio                              = "pocfratio"
    case pfcfRatio                              = "pfcfRatio"
    case pbRatio                                = "pbRatio"
    case evToSales                              = "evToSales"
    case enterpriseValueOverEBITDA              = "enterpriseValueOverEBITDA"
    case evToOperatingCashFlow                  = "evToOperatingCashFlow"
    case evToFreeCashFlow                       = "evToFreeCashFlow"
    case earningsYield                          = "earningsYield"
    case freeCashFlowYield                      = "freeCashFlowYield"
    case debtToEquity                           = "debtToEquity"
    case debtToAssets                           = "debtToAssets"
    case netDebtToEBITDA                        = "netDebtToEBITDA"
    case currentRatio                           = "currentRatio"
    case interestCoverage                       = "interestCoverage"
    case incomeQuality                          = "incomeQuality"
    case dividendYield                          = "dividendYield"
    case payoutRatio                            = "payoutRatio"
    case salesGeneralAndAdministrativeToRevenue = "salesGeneralAndAdministrativeToRevenue"
    case researchAndDdevelopementToRevenue      = "researchAndDdevelopementToRevenue"
    case intangiblesToTotalAssets               = "intangiblesToTotalAssets"
    case capexToOperatingCashFlow               = "capexToOperatingCashFlow"
    case capexToRevenue                         = "capexToRevenue"
    case capexToDepreciation                    = "capexToDepreciation"
    case stockBasedCompensationToRevenue        = "stockBasedCompensationToRevenue"
    case grahamNumber                           = "grahamNumber"
    case roic                                   = "roic"
    case grahamNetNet                           = "grahamNetNet"
    case workingCapital                         = "workingCapital"
    case tangibleAssetValue                     = "tangibleAssetValue"
    case netCurrentAssetValue                   = "netCurrentAssetValue"
    case investedCapital                        = "investedCapital"
    case averageReceivables                     = "averageReceivables"
    case averagePayables                        = "averagePayables"
    case averageInventory                       = "averageInventory"
    case daysSalesOutstanding                   = "daysSalesOutstanding"
    case daysPayablesOutstanding                = "daysPayablesOutstanding"
    case daysOfInventoryOnHand                  = "daysOfInventoryOnHand"
    case receivablesTurnover                    = "receivablesTurnover"
    case payablesTurnover                       = "payablesTurnover"
    case inventoryTurnover                      = "inventoryTurnover"
    case roe                                    = "roe"
    case capexPerShare                          = "capexPerShare"

    
    var text: String {
        switch self {
        case .symbol                                 : return "Symbol"
        case .date                                   : return "Date"
        case .revenuePerShare                        : return "Revenue per share"
        case .netIncomePerShare                      : return "EPS"
        case .operatingCashFlowPerShare              : return "OCF/Sh"
        case .freeCashFlowPerShare                   : return "FCF/Sh"
        case .cashPerShare                           : return "Cash per share"
        case .bookValuePerShare                      : return "B/sh"
        case .tangibleBookValuePerShare              : return "Tangible B/sh"
        case .shareholdersEquityPerShare             : return "Shareholders equity / Sh"
        case .interestDebtPerShare                   : return "Interest debt / Sh"
        case .marketCap                              : return "Market cap"
        case .enterpriseValue                        : return "Enterprise value"
        case .peRatio                                : return "Trailing P/E"
        case .priceToSalesRatio                      : return "PS"
        case .pocfratio                              : return "P/OCF"
        case .pfcfRatio                              : return "P/FCF"
        case .pbRatio                                : return "P/B"
        case .evToSales                              : return "EV/sales"
        case .enterpriseValueOverEBITDA              : return "EV/EBITDA"
        case .evToOperatingCashFlow                  : return "EV/OCF"
        case .evToFreeCashFlow                       : return "EV/FCF"
        case .earningsYield                          : return "Earnings yield"
        case .freeCashFlowYield                      : return "FCF yield"
        case .debtToEquity                           : return "Debt / equity"
        case .debtToAssets                           : return "Debt / assets"
        case .netDebtToEBITDA                        : return "Net debt / EBITDA"
        case .currentRatio                           : return "Current ratio"
        case .interestCoverage                       : return "Interest coverage"
        case .incomeQuality                          : return "Income quality"
        case .dividendYield                          : return "Dividend yield"
        case .payoutRatio                            : return "Payout ratio"
        case .salesGeneralAndAdministrativeToRevenue : return "SG&A / revenue"
        case .researchAndDdevelopementToRevenue      : return "R&D / revenue"
        case .intangiblesToTotalAssets               : return "Intangibles / total assets"
        case .capexToOperatingCashFlow               : return "Capex / OCF"
        case .capexToRevenue                         : return "Capex / revenue"
        case .capexToDepreciation                    : return "Capex / depreciation"
        case .stockBasedCompensationToRevenue        : return "Stock based compensation / revenue"
        case .grahamNumber                           : return "Graham number"
        case .roic                                   : return "ROIC"
        case .grahamNetNet                           : return "Graham net net"
        case .workingCapital                         : return "Working capital"
        case .tangibleAssetValue                     : return "Tangible asset value"
        case .netCurrentAssetValue                   : return "net current asset value"
        case .investedCapital                        : return "Invested capital"
        case .averageReceivables                     : return "Average receivables"
        case .averagePayables                        : return "Average payables"
        case .averageInventory                       : return "Average inventory"
        case .daysSalesOutstanding                   : return "Days sales outstanding"
        case .daysPayablesOutstanding                : return "Days payables outstanding"
        case .daysOfInventoryOnHand                  : return "Days of inventory on hand"
        case .receivablesTurnover                    : return "Receivables turnover"
        case .payablesTurnover                       : return "Payables turnover"
        case .inventoryTurnover                      : return "Inventory turnover"
        case .roe                                    : return "ROE"
        case .capexPerShare                          : return "Capex / Sh"
        }
    }
    
    var suffixType: MetricSuffixType {
        switch self {
        case .inventoryTurnover, .payablesTurnover, .receivablesTurnover, .investedCapital, .netCurrentAssetValue, .tangibleAssetValue, .workingCapital, .enterpriseValue, .marketCap, .revenuePerShare, .netIncomePerShare, .operatingCashFlowPerShare, .freeCashFlowPerShare, .cashPerShare, .bookValuePerShare, .tangibleBookValuePerShare: return .money
        case .roic, .earningsYield, .dividendYield, .freeCashFlowYield : return .percentage
        default: return .none
        }
    }
    
    var filterType: MetricFilterType {
        switch self {
        case .date, .symbol: return .none
        default: return .metric
        }
    }
}

struct KeyMetrics: Codable, Financial {
    var symbol                                 : String
    var date                                   : String
    var period                                 : FiscalPeriod
    var revenuePerShare                        : KeyMetricsFinancialMetric?
    var netIncomePerShare                      : KeyMetricsFinancialMetric?
    var operatingCashFlowPerShare              : KeyMetricsFinancialMetric?
    var freeCashFlowPerShare                   : KeyMetricsFinancialMetric?
    var cashPerShare                           : KeyMetricsFinancialMetric?
    var bookValuePerShare                      : KeyMetricsFinancialMetric?
    var tangibleBookValuePerShare              : KeyMetricsFinancialMetric?
    var shareholdersEquityPerShare             : KeyMetricsFinancialMetric?
    var interestDebtPerShare                   : KeyMetricsFinancialMetric?
    var marketCap                              : KeyMetricsFinancialMetric?
    var enterpriseValue                        : KeyMetricsFinancialMetric?
    var peRatio                                : KeyMetricsFinancialMetric?
    var priceToSalesRatio                      : KeyMetricsFinancialMetric?
    var pocfratio                              : KeyMetricsFinancialMetric?
    var pfcfRatio                              : KeyMetricsFinancialMetric?
    var pbRatio                                : KeyMetricsFinancialMetric?
    var evToSales                              : KeyMetricsFinancialMetric?
    var enterpriseValueOverEBITDA              : KeyMetricsFinancialMetric?
    var evToOperatingCashFlow                  : KeyMetricsFinancialMetric?
    var evToFreeCashFlow                       : KeyMetricsFinancialMetric?
    var earningsYield                          : KeyMetricsFinancialMetric?
    var freeCashFlowYield                      : KeyMetricsFinancialMetric?
    var debtToEquity                           : KeyMetricsFinancialMetric?
    var debtToAssets                           : KeyMetricsFinancialMetric?
    var netDebtToEBITDA                        : KeyMetricsFinancialMetric?
    var currentRatio                           : KeyMetricsFinancialMetric?
    var interestCoverage                       : KeyMetricsFinancialMetric?
    var incomeQuality                          : KeyMetricsFinancialMetric?
    var dividendYield                          : KeyMetricsFinancialMetric?
    var payoutRatio                            : KeyMetricsFinancialMetric?
    var salesGeneralAndAdministrativeToRevenue : KeyMetricsFinancialMetric?
    var researchAndDdevelopementToRevenue      : KeyMetricsFinancialMetric?
    var intangiblesToTotalAssets               : KeyMetricsFinancialMetric?
    var capexToOperatingCashFlow               : KeyMetricsFinancialMetric?
    var capexToRevenue                         : KeyMetricsFinancialMetric?
    var capexToDepreciation                    : KeyMetricsFinancialMetric?
    var stockBasedCompensationToRevenue        : KeyMetricsFinancialMetric?
    var grahamNumber                           : KeyMetricsFinancialMetric?
    var roic                                   : KeyMetricsFinancialMetric?
    var grahamNetNet                           : KeyMetricsFinancialMetric?
    var workingCapital                         : KeyMetricsFinancialMetric?
    var tangibleAssetValue                     : KeyMetricsFinancialMetric?
    var netCurrentAssetValue                   : KeyMetricsFinancialMetric?
    var investedCapital                        : KeyMetricsFinancialMetric?
    var averageReceivables                     : KeyMetricsFinancialMetric?
    var averagePayables                        : KeyMetricsFinancialMetric?
    var averageInventory                       : KeyMetricsFinancialMetric?
    var daysSalesOutstanding                   : KeyMetricsFinancialMetric?
    var daysPayablesOutstanding                : KeyMetricsFinancialMetric?
    var daysOfInventoryOnHand                  : KeyMetricsFinancialMetric?
    var receivablesTurnover                    : KeyMetricsFinancialMetric?
    var payablesTurnover                       : KeyMetricsFinancialMetric?
    var inventoryTurnover                      : KeyMetricsFinancialMetric?
    var roe                                    : KeyMetricsFinancialMetric?
    var capexPerShare                          : KeyMetricsFinancialMetric?
    
    var metrics: [AnyMetric] {
        let arr: NSMutableArray = []
        
        if let revenuePerShare                        = revenuePerShare { arr.add(AnyMetric(revenuePerShare)) }
        if let netIncomePerShare                      = netIncomePerShare { arr.add(AnyMetric(netIncomePerShare)) }
        if let operatingCashFlowPerShare              = operatingCashFlowPerShare { arr.add(AnyMetric(operatingCashFlowPerShare)) }
        if let freeCashFlowPerShare                   = freeCashFlowPerShare { arr.add(AnyMetric(freeCashFlowPerShare)) }
        if let cashPerShare                           = cashPerShare { arr.add(AnyMetric(cashPerShare)) }
        if let bookValuePerShare                      = bookValuePerShare { arr.add(AnyMetric(bookValuePerShare)) }
        if let tangibleBookValuePerShare              = tangibleBookValuePerShare { arr.add(AnyMetric(tangibleBookValuePerShare)) }
        if let shareholdersEquityPerShare             = shareholdersEquityPerShare { arr.add(AnyMetric(shareholdersEquityPerShare)) }
        if let interestDebtPerShare                   = interestDebtPerShare { arr.add(AnyMetric(interestDebtPerShare)) }
        if let enterpriseValue                        = enterpriseValue { arr.add(AnyMetric(enterpriseValue)) }
        if let peRatio                                = peRatio { arr.add(AnyMetric(peRatio)) }
        if let priceToSalesRatio                      = priceToSalesRatio { arr.add(AnyMetric(priceToSalesRatio)) }
        if let pfcfRatio                              = pfcfRatio { arr.add(AnyMetric(pfcfRatio)) }
        if let pbRatio                                = pbRatio { arr.add(AnyMetric(pbRatio)) }
        if let evToSales                              = evToSales { arr.add(AnyMetric(evToSales)) }
        if let enterpriseValueOverEBITDA              = enterpriseValueOverEBITDA { arr.add(AnyMetric(enterpriseValueOverEBITDA)) }
        if let evToFreeCashFlow                       = evToFreeCashFlow { arr.add(AnyMetric(evToFreeCashFlow)) }
        if let earningsYield                          = earningsYield { arr.add(AnyMetric(earningsYield)) }
        if let freeCashFlowYield                      = freeCashFlowYield { arr.add(AnyMetric(freeCashFlowYield)) }
        if let debtToEquity                           = debtToEquity { arr.add(AnyMetric(debtToEquity)) }
        if let debtToAssets                           = debtToAssets { arr.add(AnyMetric(debtToAssets)) }
        if let netDebtToEBITDA                        = netDebtToEBITDA { arr.add(AnyMetric(netDebtToEBITDA)) }
        if let currentRatio                           = currentRatio { arr.add(AnyMetric(currentRatio)) }
        if let incomeQuality                          = incomeQuality { arr.add(AnyMetric(incomeQuality)) }
        if let payoutRatio                            = payoutRatio { arr.add(AnyMetric(payoutRatio)) }
        if let salesGeneralAndAdministrativeToRevenue = salesGeneralAndAdministrativeToRevenue { arr.add(AnyMetric(salesGeneralAndAdministrativeToRevenue)) }
        if let researchAndDdevelopementToRevenue      = researchAndDdevelopementToRevenue { arr.add(AnyMetric(researchAndDdevelopementToRevenue)) }
        if let intangiblesToTotalAssets               = intangiblesToTotalAssets { arr.add(AnyMetric(intangiblesToTotalAssets)) }
        if let capexToOperatingCashFlow               = capexToOperatingCashFlow { arr.add(AnyMetric(capexToOperatingCashFlow)) }
        if let capexToRevenue                         = capexToRevenue { arr.add(AnyMetric(capexToRevenue)) }
        if let capexToDepreciation                    = capexToDepreciation { arr.add(AnyMetric(capexToDepreciation)) }
        if let stockBasedCompensationToRevenue        = stockBasedCompensationToRevenue { arr.add(AnyMetric(stockBasedCompensationToRevenue)) }
        if let grahamNumber                           = grahamNumber { arr.add(AnyMetric(grahamNumber)) }
        if let roic                                   = roic { arr.add(AnyMetric(roic)) }
        if let grahamNetNet                           = grahamNetNet { arr.add(AnyMetric(grahamNetNet)) }
        if let workingCapital                         = workingCapital { arr.add(AnyMetric(workingCapital)) }
        if let netCurrentAssetValue                   = netCurrentAssetValue { arr.add(AnyMetric(netCurrentAssetValue)) }
        if let averagePayables                        = averagePayables { arr.add(AnyMetric(averagePayables)) }
        if let daysSalesOutstanding                   = daysSalesOutstanding { arr.add(AnyMetric(daysSalesOutstanding)) }
        if let daysPayablesOutstanding                = daysPayablesOutstanding { arr.add(AnyMetric(daysPayablesOutstanding)) }
        if let daysOfInventoryOnHand                  = daysOfInventoryOnHand { arr.add(AnyMetric(daysOfInventoryOnHand)) }
        if let receivablesTurnover                    = receivablesTurnover { arr.add(AnyMetric(receivablesTurnover)) }
        if let payablesTurnover                       = payablesTurnover { arr.add(AnyMetric(payablesTurnover)) }
        if let roe                                    = roe { arr.add(AnyMetric(roe)) }
        if let capexPerShare                          = capexPerShare { arr.add(AnyMetric(capexPerShare)) }
        if let pocfratio                              = pocfratio { arr.add(AnyMetric(pocfratio)) }
        if let evToOperatingCashFlow                  = evToOperatingCashFlow { arr.add(AnyMetric(evToOperatingCashFlow)) }
        if let averageReceivables                     = averageReceivables { arr.add(AnyMetric(averageReceivables)) }
        if let inventoryTurnover                      = inventoryTurnover { arr.add(AnyMetric(inventoryTurnover)) }
        if let averageInventory                       = averageInventory { arr.add(AnyMetric(averageInventory)) }
        if let interestCoverage                       = interestCoverage { arr.add(AnyMetric(interestCoverage)) }
        if let dividendYield                          = dividendYield { arr.add(AnyMetric(dividendYield)) }
        if let tangibleAssetValue                     = tangibleAssetValue { arr.add(AnyMetric(tangibleAssetValue)) }
        if let investedCapital                        = investedCapital { arr.add(AnyMetric(investedCapital)) }
        
        return arr as? [AnyMetric] ?? []
    }
    
    var ocf: Double? {
        return operatingCashFlowPerShare?.doubleValue
    }
}
