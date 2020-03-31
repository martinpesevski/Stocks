//
//  StocksViewModel.swift
//  stocks
//
//  Created by Martin Peshevski on 3/31/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

class StocksViewModel {
    var filters: [Filter] = []
    var searchText = ""
    var stocks: [Stock]
    var filteredStocks: [Stock]

    init(stocks: [Stock]) {
        self.stocks = stocks
        self.filteredStocks = stocks
    }

    func filter(filters: [Filter], shouldSearch: Bool = true) {
        self.filters = filters
        filteredStocks = stocks.filter { $0.isValid(filters: filters) }
        filteredStocks.sort { $0.intrinsicValue!.discount > $1.intrinsicValue!.discount }
        if shouldSearch { search(searchText, shouldFilter: false) }
    }

    func search(_ text: String?, shouldFilter: Bool = true) {
        guard let text = text, !text.isEmpty else {
            searchText = ""
            filter(filters: self.filters, shouldSearch: false)
            return
        }
        searchText = text
        if shouldFilter { filter(filters: self.filters, shouldSearch: false)}
        filteredStocks = filteredStocks.filter { $0.ticker.detailName.uppercased().contains(text.uppercased()) }
    }
}