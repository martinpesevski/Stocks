//
//  GrowthMetrics.swift
//  stocks
//
//  Created by Martin Peshevski on 3/16/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct GrowthMetricsArray: Codable, StockIdentifiable {
    static func stockIdentifier(_ ticker: String) -> String {
        return "growthMetrics\(ticker)"
    }

    var symbol: String?
    var growth: [GrowthMetrics]?
}
struct GrowthMetrics: Codable {
    var date: String
    var fiveYearRev: String
    var tenYearRev: String
    var fiveYearNetIncome: String
    var tenYearNetIncome: String
    var fiveYearOCF: String
    var tenYearOCF: String

    private enum CodingKeys: String, CodingKey {
        case date
        case fiveYearRev = "5Y Revenue Growth (per Share)"
        case tenYearRev = "10Y Revenue Growth (per Share)"
        case fiveYearNetIncome = "5Y Net Income Growth (per Share)"
        case tenYearNetIncome = "10Y Net Income Growth (per Share)"
        case fiveYearOCF = "5Y Operating CF Growth (per Share)"
        case tenYearOCF = "10Y Operating CF Growth (per Share)"
    }
}
