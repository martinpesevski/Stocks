//
//  ViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 2/18/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tickers: [Ticker] = []
    var stocks: [Stock] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        URLSession.shared.datatask(type: Ticker.self, url: Endpoints.tickers.url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                if let error = error { print(" error getting Tickers: \(error.localizedDescription)")}
                return }
            self.tickers = data
            self.tickers.forEach { self.stocks.append(Stock(ticker: $0))}

            let group = DispatchGroup()

            for stock in self.stocks { stock.getBalanceSheet(group: group) }
            group.notify(queue: .main) {
                print(self.stocks)
            }
        }
    }
}
