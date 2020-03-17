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
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let data = UserDefaults.standard.object(forKey: "tickerData") as? Data else {
            load()
            return
        }

        DataParser.parseJson(type: TickerArray.self, data: data) { array, error in
            guard let array = array else { return }
            self.setupStocks(data: array)
        }
    }

    func load() {
        URLSession.shared.dataTask(with: Endpoints.tickers.url) {
            [weak self] data, response, error in

            guard let self = self, let data = data else {
                return }

            UserDefaults.standard.set(data, forKey: "tickerData")
            DataParser.parseJson(type: TickerArray.self, data: data) { array, error in
                if let array = array { self.setupStocks(data: array)}
                if let error = error { NSLog("error loading tickers" + error.localizedDescription) }
            }
        }.resume()
    }

    func setupStocks(data: TickerArray) {
        self.tickers = data.symbolsList.filter { $0.isValid }.sorted { return $0.symbol < $1.symbol }
        self.tickers.forEach { self.stocks.append(Stock(ticker: $0)) }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        let group = DispatchGroup()
        for (index, stock) in self.stocks.enumerated() {
            group.enter()
            stock.load {
                group.leave()
                DispatchQueue.main.async {
                    (self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? StockCell)?.setup(stock: stock)
                }
            }
        }
        group.notify(queue: .main) {
            self.stocks = self.stocks.filter { $0.isValid }
            self.stocks.sort { $0.discount! > $1.discount! }
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        let stock = stocks[indexPath.row]
        cell.setup(stock: stock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
}
