//
//  Networking.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

let apiKey = "24000acc2bb9d552b74092e7f0c288c8"

enum Endpoints {
    case tickers
    case keyMetrics(ticker: String)
    case growthMetrics(ticker: String)
    case quote(ticker: String)
    case intrinsicValue(ticker: String)
    case stockScreener(sector: String?, marketCap: String?)
    case balanceSheetAnnual(ticker: String)
    case incomeStatementAnnual(ticker: String)
    case cashFlowAnnual(ticker: String)

    var url: URL {
        switch self {
        case .tickers: return URL(string: "https://financialmodelingprep.com/api/v3/company/stock/list") ?? URL(fileURLWithPath: "")
        case .keyMetrics(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company-key-metrics/\(ticker)") ?? URL(fileURLWithPath: "")
        case .growthMetrics(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/financial-statement-growth/\(ticker)") ?? URL(fileURLWithPath: "")
        case .quote(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company/profile/\(ticker)") ?? URL(fileURLWithPath: "")
        case .intrinsicValue(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company/discounted-cash-flow/\(ticker)") ?? URL(fileURLWithPath: "")
        case .balanceSheetAnnual(ticker: let ticker): return URL(string: "https://fmpcloud.io/api/v3/balance-sheet-statement/\(ticker)?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .incomeStatementAnnual(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/financials/income-statement/\(ticker)") ?? URL(fileURLWithPath: "")
        case .cashFlowAnnual(ticker: let ticker): return URL(string: "https://fmpcloud.io/api/v3/cash-flow-statement/\(ticker)?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
        case .stockScreener(sector: let sector, marketCap: let marketCap):
            switch (sector, marketCap) {
            case (let sector?, let marketCap?):
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?sector=\(sector)&\(marketCap)&apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
            case (nil, let marketCap?):
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?\(marketCap)&apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
            case (let sector?, nil):
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?sector=\(sector)&apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
            default:
                return URL(string: "https://fmpcloud.io/api/v3/stock-screener?apikey=\(apiKey)") ?? URL(fileURLWithPath: "")
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
