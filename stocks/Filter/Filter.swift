//
//  Filter.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum FilterType: TitleDescription {
    case marketCap(filters: [CapFilter])
    case profitability(filters: [ProfitabilityFilter])
    case sector(filters: [SectorFilter])
    
    var title: String {
        switch self {
        case .marketCap: return "Market cap"
        case .profitability: return "Profitability"
        case .sector: return "Industry Sector"
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
        }
        
        return text
    }
}

struct Filter: Equatable {
    var capFilters: [CapFilter] = []
    var profitabilityFilters: [ProfitabilityFilter] = []
    
    var isEmpty: Bool {
        capFilters.isEmpty && profitabilityFilters.isEmpty
    }
    
    func isValid(_ filter: Filter) -> Bool {
        guard !filter.isEmpty else { return true }
        
        for cap in filter.capFilters where !capFilters.contains(cap) {
            if !capFilters.isEmpty { return false }
        }
        
        for prof in filter.profitabilityFilters where !profitabilityFilters.contains(prof) {
            if !profitabilityFilters.isEmpty { return false }
        }
        
        return true
    }
    
    mutating func add(_ filter: TitleDescription) {
        if let cap = filter as? CapFilter, !capFilters.contains(cap) {
            capFilters.append(cap)
        } else if let prof = filter as? ProfitabilityFilter, !profitabilityFilters.contains(prof) {
            profitabilityFilters.append(prof)
        }
    }
}

protocol TitleDescription {
    var title: String { get }
    var explanation: String { get }
}

enum ProfitabilityFilter: TitleDescription, Equatable {
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

enum CapFilter: TitleDescription, Equatable {
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

enum SectorFilter: TitleDescription, Equatable {
    case energy
    case basicMaterials
    case industrials
    case consumerCyclical
    case consumerDefensive
    case healthcare
    case financial
    case tech
    case communicationServices
    case utilities
    case realEstate

    var queryString: String {
        switch self {
        case .energy: return "energy"
        case .basicMaterials: return "basic materials"
        case .industrials: return "industrials"
        case .consumerCyclical: return "consumer cyclical"
        case .consumerDefensive: return "consumer defensive"
        case .healthcare: return "healthcare"
        case .financial: return "financial"
        case .tech: return "tech"
        case .communicationServices: return "communication services"
        case .utilities: return "utilities"
        case .realEstate: return "real estate"
        }
    }
    
    var title: String {
        switch self {
        case .energy: return "Energy"
        case .basicMaterials: return "Basic Materials"
        case .industrials: return "Industrials"
        case .consumerCyclical: return "Consumer Cyclical"
        case .consumerDefensive: return "Consumer Defensive"
        case .healthcare: return "Healthcare"
        case .financial: return "Financial"
        case .tech: return "Tech"
        case .communicationServices: return "Communication Services"
        case .utilities: return "Utilities"
        case .realEstate: return "Real Estate"
        }
    }

    var explanation: String {
        switch self {
        case .energy: return "The energy sector contains oil, gas, coal, and fuel companies, as well as energy equipment and services. You can think of the equipment and services as the companies that build oil-drilling equipment, and the services as companies that oil companies hire. The stock prices of these companies are relatively stable, and the generous dividends can make them a good long-term hold. They can also be a good choice if you’re looking to get defensive in a rough market."
            
        case .basicMaterials: return "The basic materials sector are chemical, construction materials, packaging, metals, and paper companies. You can think of these companies as being at the beginning of the supply chain. They provide the steel for cars, the wood for homes, the plastics for packaging, and much more."
            
        case .industrials: return "The defense, machinery, aerospace, airlines, construction, and manufacturing companies are in this sector. These industrials usually generate lots of cash flow and have stable dividends."
            
        case .consumerCyclical: return "These are companies where you and I spend a lot of our money. It’s where our discretionary income goes. It’s the retailers, apparel, restaurants, autos, hotels, media, and household products."
            
        case .consumerDefensive: return "These are the food, beverage, and tobacco companies. They’re also manufacturers of household goods and personal products, as well as supermarkets. This is considered a defensive sector because these companies are generally resilient in the event of an economic downturn."
            
        case .healthcare: return "Companies in the healthcare sector are the pharmaceuticals, healthcare equipment, and healthcare services. The companies in this sector are often good plays and safe bets because people will always need medical care, whether it’s from pharmaceutical drugs or hospital visits."
            
        case .financial: return "The financial sector consists of banks, insurance, and real estate companies. This sector is closely tied with interest rates. If interest rates increase, then big banks make billions of dollars more. This is because banks give out loans and mortgages, and the higher interest rates all go to the banks."
            
        case .tech: return "Companies in this sector include internet, software, and semiconductor companies. Also included are companies that manufacture electronic equipment, data processing, communication equipment, and IT services."
            
        case .communicationServices: return "This sector is companies in the communication services. Most of the companies in this sector rely heavily on recurring revenue, while some others earn the bulk of their revenue from advertising revenue."
            
        case .utilities: return "These companies are your electric, gas, and water utilities. They have little to no competition in the areas they operate, and local governments regulate most of their prices. This is considered a defensive sector because people will always need what these companies sell. Like most sectors, they’re subject to heavy government regulation, but they’re safe bets in a shaky market environment."
            
        case .realEstate: return "These are real estate companies called REITs (real estate investment trust) and real estate developers. Companies in this sector earn their revenue from rent income and increasing property values. And since they pay out at least 90% of their taxable profit as a dividend to shareholders, they’re usually great for a long-term hold, with dividend checks coming every three months."
        }
    }
}
