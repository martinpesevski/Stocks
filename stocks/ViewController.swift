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

        URLSession.shared.datatask(type: TickerArray.self, url: Endpoints.tickers.url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                if let error = error { print(" error getting Tickers: \(error.localizedDescription)") }
                return }
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
                self.stocks = self.stocks.filter {
                    $0.intrinsicValue != nil &&
                        $0.intrinsicValue! > 0 &&
                        Float($0.growthMetrics![0].fiveYearNetIncome) != nil &&
                        Float($0.growthMetrics![0].fiveYearNetIncome)! > 0
                }
                self.stocks.sort { $0.discount! > $1.discount!}
                self.tableView.reloadData()
            }
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
