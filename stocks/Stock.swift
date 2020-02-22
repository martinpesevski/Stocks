//
//  Stock.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct Ticker: Codable {
    var simId: Int
    var ticker: String?
    var name: String?
}

class Stock {
    var ticker: Ticker
    var balanceSheet: BalanceSheet?

    init(ticker: Ticker) {
        self.ticker = ticker
    }

    func getBalanceSheet(group: DispatchGroup) {

        group.enter()
        URLSession.shared.objectDatatask(type: BalanceSheet.self, url: Endpoints.balanceSheet(tickerID: ticker.simId).url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                if let error = error { print(error.localizedDescription) }
                group.leave()
                return }
            self.balanceSheet = data
            group.leave()
        }
    }
}

struct BalanceSheet: Codable {
    var periodEndDate: String?
    var industryTemplate: String?
    var values: [BalanceSheetValue]?
}

struct BalanceSheetValue: Codable {
    var tid: String
    var uid: String
    var standardisedName: String
    var parent_tid: String
    var valueCalculated: Int
//    var checkPossible: String
}
