//
//  Networking.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

extension String {
    static let apiKey: String = "api-key=yMkcG8wIzSWHaoSXkgmHjPEHSA95JTvq"
}

enum Endpoints {
    case tickers
    case keyMetrics(ticker: String)
    case growthMetrics(ticker: String)
    case intrinsicValue(ticker: String)
    
    var url: URL {
        switch self {
        case .tickers: return URL(string: "https://financialmodelingprep.com/api/v3/company/stock/list") ?? URL(fileURLWithPath: "")
        case .keyMetrics(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company-key-metrics/\(ticker)") ?? URL(fileURLWithPath: "")
        case .growthMetrics(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/financial-statement-growth/\(ticker)") ?? URL(fileURLWithPath: "")
        case .intrinsicValue(ticker: let ticker): return URL(string: "https://financialmodelingprep.com/api/v3/company/discounted-cash-flow/\(ticker)") ?? URL(fileURLWithPath: "")
        }
    }
}

extension URLSession {
    func datatask<T: Codable>(type: T.Type, url: URL, completion: @escaping (T?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion(nil, response, error) }

            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(object, response, error)
            } catch let error as NSError {
               completion(nil, response, error)
            }
        }.resume()
    }
}
