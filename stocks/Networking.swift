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
    case balanceSheet(tickerID: Int)

    var url: URL {
        switch self {
        case .tickers: return URL(string: "https://simfin.com/api/v1/info/all-entities?\(String.apiKey)") ?? URL(fileURLWithPath: "")
        case .balanceSheet(let tickerID): return URL(string: "https://simfin.com/api/v1/companies/id/\(tickerID)/statements/standardised?stype=bs&ptype=TTM&fyear=2018&\(String.apiKey)") ?? URL(fileURLWithPath: "")
        }
    }
}

extension URLSession {
    func datatask<T: Codable>(type: T.Type, url: URL, completion: @escaping ([T]?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion(nil, response, error) }

            do {
                let array = try JSONDecoder().decode([T].self, from: data)
                completion(array, response, error)
            } catch let error as NSError {
               completion(nil, response, error)
            }
        }.resume()
    }

    func objectDatatask<T: Codable>(type: T.Type, url: URL, completion: @escaping (T?, URLResponse?, Error?) -> Void) {
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
