//
//  CapFilter.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum CapFilter: String, TitleDescription, Equatable, Codable {
    case largeCap
    case midCap
    case smallCap

    var marketCap: MarketCap? {
        switch self {
        case .largeCap: return .large
        case .midCap: return .medium
        case .smallCap: return .small
        }
    }
    
    var queryString: String {
        switch self {
        case .smallCap: return "marketCapLowerThan=1000000000"
        case .midCap: return "marketCapMoreThan=1000000000&marketCapLowerThan=50000000000"
        case .largeCap: return "marketCapMoreThan=50000000000"
        }
    }

    var title: String {
        switch self {
        case .largeCap: return "Large Cap"
        case .midCap: return "Mid Cap"
        case .smallCap: return "Small Cap"
        }
    }

    var explanation: String {
        switch self {
        case .largeCap: return "Companies with market cap larger than $50 billion"
        case .midCap: return "Companies with market cap between $1 billion and $50 billion"
        case .smallCap: return "Companies smaller than $1 billion"
        }
    }
}
