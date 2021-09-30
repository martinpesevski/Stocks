//
//  Profile.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct Quote: Codable, StockIdentifiable {
    static func stockIdentifier(_ ticker: String) -> String {
        return "quote\(ticker)"
    }

    var symbol: String?
    var profile: Profile

    var marketCap: MarketCap? {
        guard let marketCap = profile.mktCap?.doubleValue else { return nil }

        return MarketCap.fromValue(marketCap)
    }
    
    var sector: SectorFilter? {
        guard let name = profile.sector else { return nil }
        return SectorFilter.sectorForName(name)
    }
}

struct Profile: Codable {
    var price: Float?
    var beta: String?
    var volAvg: String?
    var mktCap: String?
    var exchange: String?
    var changes: Float?
    var changesPercentage: String?
    var companyName: String?
    var industry: String?
    var sector: String?
    var website: String?
    var description: String?
    var ceo: String?
    var image: String?
}
