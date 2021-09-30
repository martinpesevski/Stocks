//
//  SectorFilter.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum SectorFilter: String, TitleDescription, Equatable, Codable, CaseIterable {
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
        case .tech: return "Technology"
        case .communicationServices: return "Communication Services"
        case .utilities: return "Utilities"
        case .realEstate: return "Real Estate"
        }
    }
    
    static func sectorForName(_ name: String) -> SectorFilter? {
        for sector in SectorFilter.allCases {
            if sector.title == name { return sector }
        }
        return nil
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
