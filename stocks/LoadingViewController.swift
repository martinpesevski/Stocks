//
//  LoadingViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/17/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    var tickers: [Ticker] = []
    var stocks: [Stock] = []

    @IBOutlet var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.performSegue(withIdentifier: "filter", sender: self)

        animationView.animation = Animation.named("loading")
        animationView.loopMode = .loop
        animationView.play()

        guard let data = UserDefaults.standard.object(forKey: "tickerData") as? Data else {
            load()
            return
        }

        DispatchQueue.global(qos: .background).async {
            DataParser.parseJson(type: TickerArray.self, data: data) { array, error in
                guard let array = array else { return }
                self.setupStocks(data: array)
            }
        }
    }
    
    func load() {
        URLSession.shared.dataTask(with: Endpoints.tickers.url) {
            [weak self] data, response, error in
            guard let self = self, let data = data else { return }

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

        let group = DispatchGroup()
        for stock in self.stocks {
            group.enter()
            stock.load {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "filter", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filter = segue.destination as? FilterViewController {
            filter.stocks = stocks
        }
    }
}
