//
//  KeyMetrics.swift
//  stocks
//
//  Created by Martin Peshevski on 3/16/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct KeyMetricsArray: Codable, StockIdentifiable {
    static func stockIdentifier(_ ticker: String) -> String {
        return "keyMetrics\(ticker)"
    }

    var metrics: [KeyMetrics]?
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
}

protocol StockIdentifiable {
    static func stockIdentifier(_ ticker: String) -> String
}

extension String {
    var floatValue: Float? { Float(self) }
}
