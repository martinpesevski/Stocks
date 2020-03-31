//
//  Filter.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum Filter {
    case largeCap
    case midCap
    case smallCap
    case profitable
    case unprofitable
    case search(_ text: String)

    var marketCap: Stock.MarketCap? {
        switch self {
        case .largeCap: return .large
        case .midCap: return .medium
        case .smallCap: return .small
        default: return nil
        }
    }

    var profitability: Stock.Profitability? {
        switch self {
        case .profitable: return .profitable
        case .unprofitable: return .unprofitable
        default: return nil
        }
    }

    var title: String {
        switch self {
        case .largeCap: return "Large Cap"
        case .midCap: return "Mid Cap"
        case .smallCap: return "Small Cap"
        case .profitable: return "Profitable"
        case .unprofitable: return "Unprofitable"
        case .search: return ""
        }
    }

    var explanation: String {
        switch self {
        case .largeCap: return "Companies with market cap larger than $50 billion"
        case .midCap: return "Companies with market cap between $1 billion and $50 billion"
        case .smallCap: return "Companies smaller than $1 billion"
        case .profitable: return "Companies that reported profit on average in the past 10 years"
        case .unprofitable: return "Companies that reported loss on average in the past 10 years"
        case .search: return ""
        }
    }
}

extension Sequence where Iterator.Element == Filter
{
    var hasProfitability: Bool {
        for filter in self where filter.profitability != nil {
            return true
        }

        return false
    }

    var hasMarketCap: Bool {
        for filter in self where filter.marketCap != nil {
            return true
        }

        return false
    }
}
