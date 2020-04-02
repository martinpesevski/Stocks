//
//  KeyMetrics.swift
//  stocks
//
//  Created by Martin Peshevski on 3/16/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct KeyMetricsArray: Codable, StockIdentifiable {
    static func stockIdentifier(_ ticker: String) -> String {
        return "keyMetrics\(ticker)"
    }

    var metrics: [KeyMetrics]?

    var averageOCFGrowth: Float? {
        guard let metrics = metrics else { return nil }
        let ocfMetrics = metrics.compactMap { $0.ocf }.sorted { $0 < $1 }
        var total: Float = 0
        for (index, value) in ocfMetrics.enumerated() where index > 0 {
            total += (value - ocfMetrics[index - 1]) / value
        }
        return total / Float(ocfMetrics.count)
    }

    var projectedFutureGrowth: Float? {
        guard let averageOCFGrowth = averageOCFGrowth else { return nil }
        return min(averageOCFGrowth, 0.15)
    }

    var profitability: Profitability? {
        guard let metrics = metrics, !metrics.isEmpty else { return nil }

        var netIncomeAverage: Float = 0
        let netIncomes = metrics.compactMap { $0.netIncomePerShare.floatValue }
        for value in netIncomes {
            netIncomeAverage += value
        }
        netIncomeAverage /= Float(netIncomes.count)

        return netIncomeAverage > 0 ? .profitable : .unprofitable
    }
}

struct KeyMetrics: Codable {
    var date: String
    var netIncomePerShare: String
    var operatingCFPerShare: String
    var freeCFPerShare: String
    var dividendYield: String
    var marketCap: String

    private enum CodingKeys: String, CodingKey {
        case date
        case netIncomePerShare = "Net Income per Share"
        case operatingCFPerShare = "Operating Cash Flow per Share"
        case freeCFPerShare = "Free Cash Flow per Share"
        case dividendYield = "Dividend Yield"
        case marketCap = "Market Cap"
    }

    var ocf: Float? {
        return Float(operatingCFPerShare)
    }
}
