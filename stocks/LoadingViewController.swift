//
//  LoadingViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/17/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import Lottie

class LoadingViewController: ViewController {
    var tickers: [Ticker] = []
    var stocks: [Stock] = []

    @IBOutlet var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.view.backgroundColor = .systemBackground
        animationView.animation = Animation.named("loading")
        animationView.loopMode = .loop
        animationView.play()

//        guard let data = UserDefaults.standard.object(forKey: "tickerData") as? Data else {
            load()
//            return
//        }
//
//        DispatchQueue.global(qos: .background).async {
//            DataParser.parseJson(type: TickerArray.self, data: data) { array, error in
//                guard let array = array else { return }
//                self.setupStocks(data: array)
//            }
        }

    
    func load() {
        URLSession.shared.dataTask(with: Endpoints.stockScreener(sector: "tech", marketCap: .large).url) {
            [weak self] data, response, error in
            guard let self = self, let data = data else { return }

            UserDefaults.standard.set(data, forKey: "tickerData")
            DataParser.parseJson(type: [Ticker].self, data: data) { array, error in
                if let array = array { self.setupStocks(data: array)}
                if let error = error { NSLog("error loading tickers" + error.localizedDescription) }
            }
        }.resume()
    }
    
    func setupStocks(data: [Ticker]) {
        self.tickers = data.sorted { return $0.symbol < $1.symbol }
        self.tickers.forEach { self.stocks.append(Stock(ticker: $0)) }

        let group = DispatchGroup()
        for stock in self.stocks {
            group.enter()
            stock.load {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let cap = FilterViewController(viewModel: StocksViewModel(stocks: self.stocks))
                self.show(cap, sender: self)
            }
        }
    }
}
