//
//  FilterType.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum FilterType: TitleDescription {
    case marketCap(filters: [CapFilter])
    case profitability(filters: [ProfitabilityFilter])
    case sector(filters: [SectorFilter])
    case metric(filters: [MetricFilter])
    
    var title: String {
        switch self {
        case .marketCap: return "Market cap"
        case .profitability: return "Profitability"
        case .sector: return "Industry Sector"
        case .metric: return "Select metrics"
        }
    }

    var explanation: String {
        var text = "Currently selected: "
        switch self {
        case .marketCap(let filters):
            for (index, filter) in filters.enumerated() {
                text += index == filters.count - 1 ? filter.title : "\(filter.title), "
            }
        case .profitability(let filters):
            for (index, filter) in filters.enumerated() {
                text += index == filters.count - 1 ? filter.title : "\(filter.title), "
            }
        case .sector(let filters):
            for (index, filter) in filters.enumerated() {
                text += index == filters.count - 1 ? filter.title : "\(filter.title), "
            }
            
        case .metric(let filters):
            for (index, filter) in filters.enumerated() {
                text += index == filters.count - 1 ? filter.title : "\(filter.title), "
            }
        }
        
        return text
    }
}
