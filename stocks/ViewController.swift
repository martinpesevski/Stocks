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

        URLSession.shared.datatask(type: Ticker.self, url: Endpoints.tickers.url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                if let error = error { print(" error getting Tickers: \(error.localizedDescription)")}
                return }
            self.tickers = data.filter { return $0.ticker != nil }.sorted { return $0.ticker! < $1.ticker! }
            self.tickers.forEach { self.stocks.append(Stock(ticker: $0))}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            let group = DispatchGroup()

            for i in 0..<3 { self.stocks[i].getBalanceSheet(group: group) }
            group.notify(queue: .main) {
                DispatchQueue.main.async { self.tableView.reloadData() }
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
