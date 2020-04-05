//
//  ProfitabilityFilter.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum ProfitabilityFilter: String, TitleDescription, Equatable, Codable {
    case profitable
    case unprofitable
    
    var profitability: Profitability? {
        switch self {
        case .profitable: return .profitable
        case .unprofitable: return .unprofitable
        }
    }
    
    var title: String {
        switch self {
        case .profitable: return "Profitable"
        case .unprofitable: return "Unprofitable"
        }
    }

    var explanation: String {
        switch self {
        case .profitable: return "Companies that reported profit on average in the past 10 years"
        case .unprofitable: return "Companies that reported loss on average in the past 10 years"
        }
    }
}
