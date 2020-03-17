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

            self.growthMetrics = data.growth
            completion?(error == nil)
        }
    }

    func getQuote(completion: ((Bool) -> ())? = nil) {
        URLSession.shared.datatask(type: Quote.self, url: Endpoints.quote(ticker: ticker.symbol).url) { [weak self] data, response, error in
            guard let self = self, let data = data else {
                completion?(false)
                return }

            self.quote = data
            completion?(error == nil)
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
