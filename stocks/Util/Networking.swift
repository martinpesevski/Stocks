//
//  Networking.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

let apiKey = "4cfc166ecb7b4b5f40361b8980dd4d82"

enum Endpoints {
    case tickers
    case keyMetrics(ticker: String, isAnnual: Bool)
    case growthMetrics(ticker: String)
    case quote(ticker: String)
    case intrinsicValue(ticker: String)
    case financialRatios(ticker: String, isAnnual: Bool)
    case stockScreener(sector: String?, marketCap: String?)
    case balanceSheet(ticker: String, isAnnual: Bool)
    case incomeStatement(ticker: String, isAnnual: Bool)
    case cashFlow(ticker: String, isAnnual: Bool)

    var url: URL {
        switch self {
        case .tickers: return URL(string: "https://financialmodelingprep.com/api/v3/stock/list?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .keyMetrics(ticker: let ticker, let isAnnual):
            let annual = isAnnual ? "" : "period=quarter&"
            return URL(string: "https://financialmodelingprep.com/api/v3/key-metrics/\(ticker)?\(annual)apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .growthMetrics(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/financial-statement-growth/\(ticker)?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .quote(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company/profile/\(ticker)?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .intrinsicValue(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company/discounted-cash-flow/\(ticker)?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case.financialRatios(ticker: let ticker, isAnnual: let isAnnual):
            let annual = isAnnual ? "" : "period=quarter&"
            return URL(string: "https://financialmodelingprep.com/api/v3/ratios/\(ticker)?\(annual)apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .balanceSheet(ticker: let ticker, let isAnnual):
            let annual = isAnnual ? "" : "period=quarter&"
            return URL(string: "https://financialmodelingprep.com/api/v3/balance-sheet-statement/\(ticker)?\(annual)apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .incomeStatement(ticker: let ticker, let isAnnual):
            let annual = isAnnual ? "" : "period=quarter&"
            return URL(string: "https://financialmodelingprep.com/api/v3/income-statement/\(ticker)?\(annual)apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .cashFlow(ticker: let ticker, let isAnnual):
            let annual = isAnnual ? "" : "period=quarter&"
            return URL(string: "https://financialmodelingprep.com/api/v3/cash-flow-statement/\(ticker)?\(annual)apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .stockScreener(sector: let sector, marketCap: let marketCap):

            switch (sector, marketCap) {
            case (let sector?, let marketCap?):
                guard let sector = sector.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return URL(fileURLWithPath: "") }
                return URL(string: "https://financialmodelingprep.com/api/v3/stock-screener?sector=\(sector)&\(marketCap)&apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
            case (nil, let marketCap?):
                return URL(string: "https://financialmodelingprep.com/api/v3/stock-screener?\(marketCap)&apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
            case (let sector?, nil):
                guard let sector = sector.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return URL(fileURLWithPath: "") }
                return URL(string: "https://financialmodelingprep.com/api/v3/stock-screener?sector=\(sector)&apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
            default:
                return URL(string: "https://financialmodelingprep.com/api/v3/stock-screener?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
            }
        }
    }
}

extension URLSession {
    func datatask<T: Codable>(type: T.Type,
                              url: URL,
                              completion: @escaping (T?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion(nil, response, error) }

            DataParser.parseJson(type: T.self, data: data) { data, error in
                switch (data, error) {
                case (let data, nil): completion(data, response, error)
                default: completion(nil, response, error)
                }
            }
        }.resume()
    }
}
