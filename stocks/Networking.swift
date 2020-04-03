//
//  Networking.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum Endpoints {
    case tickers
    case keyMetrics(ticker: String)
    case growthMetrics(ticker: String)
    case quote(ticker: String)
    case intrinsicValue(ticker: String)
    case stockScreener(sector: String?, marketCap: MarketCap?)
    
    var url: URL {
        switch self {
        case .tickers: return URL(string: "https://financialmodelingprep.com/api/v3/company/stock/list") ?? URL(fileURLWithPath: "")
        case .keyMetrics(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company-key-metrics/\(ticker)") ?? URL(fileURLWithPath: "")
        case .growthMetrics(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/financial-statement-growth/\(ticker)") ?? URL(fileURLWithPath: "")
        case .quote(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company/profile/\(ticker)") ?? URL(fileURLWithPath: "")
        case .intrinsicValue(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company/discounted-cash-flow/\(ticker)") ?? URL(fileURLWithPath: "")
        case .stockScreener(sector: let sector, marketCap: let marketCap):
            switch (sector, marketCap) {
            case (let sector?, let marketCap?):
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?sector=\(sector)&\(marketCap.queryStringValue)&apikey=bbfe8c1a2f7574cc1fac10b5eeb35d73") ?? URL(fileURLWithPath: "")
            case (nil, let marketCap?):
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?\(marketCap.queryStringValue)&apikey=bbfe8c1a2f7574cc1fac10b5eeb35d73") ?? URL(fileURLWithPath: "")
            case (let sector?, nil):
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?sector=\(sector)&apikey=bbfe8c1a2f7574cc1fac10b5eeb35d73") ?? URL(fileURLWithPath: "")
            default:
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?apikey=bbfe8c1a2f7574cc1fac10b5eeb35d73") ?? URL(fileURLWithPath: "")
            }
        }
    }
}

extension URLSession {
    func datatask<T: Codable & StockIdentifiable>(type: T.Type,
                              identifier: String? = nil,
                              url: URL,
                              completion: @escaping (T?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion(nil, response, error) }

            if let identifier = identifier {
                UserDefaults.standard.set(data, forKey: T.stockIdentifier(identifier))
            }

            DataParser.parseJson(type: T.self, data: data) { data, error in
                switch (data, error) {
                case (let data, nil): completion(data, response, error)
                default: completion(nil, response, error)
                }
            }
        }.resume()
    }
}
