//
//  Stock+Api.swift
//  stocks
//
//  Created by Martin Peshevski on 3/16/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

extension Stock {
    func getKeyMetrics(completion: ((Bool) -> ())? = nil) {
        if let name = ticker.name,
            let keyMetricsData = UserDefaults.standard.data(forKey: KeyMetricsArray.stockIdentifier(name)) {
            DataParser.parseJson(type: KeyMetricsArray.self, data: keyMetricsData) { arr, error in
                if let arr = arr {
                    self.keyMetricsOverTime = arr.metrics
                    completion?(true)
                } else if let error = error {
                    NSLog("key metrics load failed: \(error.localizedDescription)")
                    completion?(false)
                } else {
                    completion?(false)
                }
            }
        } else {
            URLSession.shared.datatask(type: KeyMetricsArray.self,
                                       identifier: ticker.name,
                                       url: Endpoints.keyMetrics(ticker: ticker.symbol).url) {
                                        [weak self] data, response, error in
                guard let self = self, let data = data else {
                    completion?(false)
                    return }

                self.keyMetricsOverTime = data.metrics
                completion?(error == nil)
            }
        }
    }

    func getGrowthMetrics(completion: ((Bool) -> ())? = nil) {
        if let name = ticker.name,
            let growthMetricsData = UserDefaults.standard.data(forKey: GrowthMetricsArray.stockIdentifier(name)) {
            DataParser.parseJson(type: GrowthMetricsArray.self, data: growthMetricsData) { arr, error in
                if let arr = arr {
                    self.growthMetrics = arr.growth
                    completion?(true)
                } else if let error = error {
                    NSLog("growth metrics load failed: \(error.localizedDescription)")
                    completion?(false)
                } else {
                    completion?(false)
                }
            }
        } else {
            URLSession.shared.datatask(type: GrowthMetricsArray.self,
                                       identifier: ticker.name,
                                       url: Endpoints.growthMetrics(ticker: ticker.symbol).url) {
                                        [weak self] data, response, error in
                guard let self = self, let data = data else {
                    completion?(false)
                    return }

                self.growthMetrics = data.growth
                completion?(error == nil)
            }
        }
    }

    func getQuote(completion: ((Bool) -> ())? = nil) {
        if let name = ticker.name,
            let quotes = UserDefaults.standard.data(forKey: Quote.stockIdentifier(name)) {
            DataParser.parseJson(type: Quote.self, data: quotes) { quote, error in
                if let quote = quote {
                    self.quote = quote
                    completion?(true)
                } else if let error = error {
                    NSLog("growth metrics load failed: \(error.localizedDescription)")
                    completion?(false)
                } else {
                    completion?(false)
                }
            }
        } else {
            URLSession.shared.datatask(type: Quote.self, identifier: ticker.name, url: Endpoints.quote(ticker: ticker.symbol).url) { [weak self] data, response, error in
                guard let self = self, let data = data else {
                    completion?(false)
                    return }

                self.quote = data
                completion?(error == nil)
            }
        }
    }

    func load(completion: @escaping ()->()) {
        group = DispatchGroup()
        group.enter()
        getKeyMetrics() { completed in self.group.leave() }
        group.enter()
        getQuote() { completed in self.group.leave() }
        group.enter()
        getGrowthMetrics() { completed in self.group.leave() }
        group.notify(queue: .main) {
            self.calculateIntrinsicValue()
            DispatchQueue.main.async { completion() }
        }
    }
}
