//
//  StocksViewModel.swift
//  stocks
//
//  Created by Martin Peshevski on 3/31/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

class StocksViewModel {
    var filter: Filter = Filter()
    var searchText = ""
    var stocks: [Stock] = []
    var filteredStocks: [Stock] = []
    var didLoadOnce = false

    func filter(filter: Filter, shouldSearch: Bool = true) {
        self.filter = filter
        filteredStocks = stocks.filter { $0.isValid(filter: filter) }
        filteredStocks.sort { $0.ticker.symbol < $1.ticker.symbol }
        if shouldSearch { search(searchText, shouldFilter: false) }
    }

    func search(_ text: String?, shouldFilter: Bool = true) {
        guard let text = text, !text.isEmpty else {
            searchText = ""
            filter(filter: self.filter, shouldSearch: false)
            return
        }
        searchText = text
        if shouldFilter { filter(filter: self.filter, shouldSearch: false)}
        filteredStocks = filteredStocks.filter { $0.ticker.detailName.uppercased().contains(text.uppercased()) }
    }
    
    func load(completion: @escaping () -> Void) {
        guard let endpoints = filter.endpoints else {
            completion()
            return
        }
        self.stocks = []

        let group = DispatchGroup()

        for endpoint in endpoints {
            group.enter()
            URLSession.shared.dataTask(with: endpoint.url) { [weak self] data, response, error in
                guard let self = self, let data = data else {
                    group.leave()
                    return
                }
                
                DataParser.parseJson(type: [Ticker].self, data: data) { array, error in
                    if let array = array {
                        self.setupStocks(data: array) {
                            self.didLoadOnce = true
                            group.leave()
                        }
                        return
                    }
                    if let error = error {
                        NSLog("error loading tickers: " + error.localizedDescription)
                        group.leave()
                    }
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func setupStocks(data: [Ticker], completion: @escaping () -> Void) {
        let tickers = data.sorted { return $0.symbol < $1.symbol }
        tickers.forEach { self.stocks.append(Stock(ticker: $0)) }
        self.filteredStocks = self.stocks

        let group = DispatchGroup()
        for stock in self.stocks {
            group.enter()
            stock.getKeyMetrics() { _ in
                stock.load {
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
}
