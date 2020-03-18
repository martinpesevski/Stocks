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
        
        animationView.animation = Animation.named("loading6")
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
            self.stocks = self.stocks.filter { $0.isValid }
            self.stocks.sort { $0.discount! > $1.discount! }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "dashboard", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dashboard = segue.destination as? ViewController {
            dashboard.stocks = stocks
        }
    }
}
