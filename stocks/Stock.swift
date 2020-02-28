//
//  Stock.swift
//  stocks
//
//  Created by Martin Peshevski on 2/19/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol StockDataDelegate: class {
    func didFinishDownloading(_ stock: Stock)
}

class Stock {
    var ticker: Ticker
    var keyMetricsOverTime: [KeyMetrics]?
    var growthMetrics: [GrowthMetrics]?
    var group = DispatchGroup()
    weak var delegate: StockDataDelegate?
    var intrinsicValue: Float?
    
    init(ticker: Ticker) {
        self.ticker = ticker
    }
    
    func getKeyMetrics(completion: ((Bool) -> ())? = nil) {
        URLSession.shared.datatask(type: KeyMetricsArray.self, url: Endpoints.keyMetrics(ticker: ticker.symbol).url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                completion?(false)
                return }
            
            self.keyMetricsOverTime = data.metrics
            completion?(error == nil)
        }
    }
    
    func getGrowthMetrics(completion: ((Bool) -> ())? = nil) {
        URLSession.shared.datatask(type: GrowthMetricsArray.self, url: Endpoints.growthMetrics(ticker: ticker.symbol).url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                completion?(false)
                return }
            
            self.growthMetrics = data.metrics
            completion?(error == nil)
        }
    }
    
    func load(completion: @escaping ()->()) {
        group = DispatchGroup()
        group.enter()
        getKeyMetrics() { completed in self.group.leave() }
        group.enter()
        getGrowthMetrics() { completed in self.group.leave() }
        group.notify(queue: .main) {
            self.calculateIntrinsicValue()
            DispatchQueue.main.async { completion() }
        }
    }
    
    func calculateIntrinsicValue() {
        guard let keyMetrics = self.keyMetricsOverTime, let growthMetrics = growthMetrics else { return }
        
        var discountedCashFlow = Float(keyMetrics[0].operatingCFPerShare) ?? 0
        let growthRate = growthMetrics[0].fiveYearNetIncome
        let discountRate: Float = 0.06
        for i in 0..<min(keyMetrics.count, growthMetrics.count) {
            let growth = 1 + (Float(growthRate) ?? 0)
            let discount = Float(i) * discountRate
            discountedCashFlow = (discountedCashFlow * growth) / discount
        }
        
        self.intrinsicValue = discountedCashFlow
    }
}

struct TickerArray: Codable {
    var symbolsList: [Ticker]
}
struct Ticker: Codable {
    var symbol: String
    var name: String?
    var price: Float
}

struct IntrinsicValue: Codable {
    var symbol: String?
    var date: String
    var dcf: Float
    var price: Float
    
    var ivColor: UIColor {
        return dcf > price ? .red : .green
    }
    
    private enum CodingKeys : String, CodingKey {
        case symbol, price = "Stock Price", date, dcf
    }
}

struct KeyMetricsArray: Codable {
    var metrics: [KeyMetrics]?
}
struct KeyMetrics: Codable {
    var date: String
    var netIncomePerShare: String
    var operatingCFPerShare: String
    var freeCFPerShare: String
    var dividendYield: String
    
    private enum CodingKeys: String, CodingKey {
        case date
        case netIncomePerShare = "Net Income per Share"
        case operatingCFPerShare = "Operating Cash Flow per Share"
        case freeCFPerShare = "Free Cash Flow per Share"
        case dividendYield = "Dividend Yield"
    }
}

struct GrowthMetricsArray: Codable {
    var metrics: [GrowthMetrics]?
}
struct GrowthMetrics: Codable {
    var date: String
    var fiveYearRev: String
    var tenYearRev: String
    var fiveYearNetIncome: String
    var tenYearNetIncome: String
    
    private enum CodingKeys: String, CodingKey {
           case date
           case fiveYearRev = "5Y Revenue Growth (per Share)"
           case tenYearRev = "10Y Revenue Growth (per Share)"
           case fiveYearNetIncome = "5Y Net Income Growth (per Share)"
           case tenYearNetIncome = "10Y Net Income Growth (per Share)"
       }
}
