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
        if let name = ticker.companyName,
            let keyMetricsData = UserDefaults.standard.data(forKey: KeyMetricsArray.stockIdentifier(name)) {
            DataParser.parseJson(type: KeyMetricsArray.self, data: keyMetricsData) { arr, error in
                if let arr = arr {
                    self.keyMetricsOverTime = arr
                    self.calculateIntrinsicValue()
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
                                       url: Endpoints.keyMetrics(ticker: ticker.symbol).url) {
                                        [weak self] data, response, error in
                                        guard let self = self, let data = data else {
                                            completion?(false)
                                            return }
                                        
                                        self.keyMetricsOverTime = data
                                        self.calculateIntrinsicValue()
                                        completion?(error == nil)
            }
        }
    }
    
    func getBalanceSheet(completion: ((Bool) -> ())? = nil) {
        let group = DispatchGroup()
        group.enter()
        var completed = false
        URLSession.shared.datatask(type: BalanceSheetArray.self,
                                   url: Endpoints.balanceSheet(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else { return }
                                    
                                    self.balanceSheetsAnnual = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.enter()
        URLSession.shared.datatask(type: BalanceSheetArray.self,
                                   url: Endpoints.balanceSheet(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.balanceSheetsAnnual = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.notify(queue: .main) {
            completion?(completed)
        }
    }
    
    func getIncomeStatement(completion: ((Bool) -> ())? = nil) {
        let group = DispatchGroup()
        group.enter()
        var completed = false
        
        URLSession.shared.datatask(type: IncomeStatementsArray.self,
                                   url: Endpoints.incomeStatement(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else { return }
                                    
                                    self.incomeStatementsAnnual = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.enter()
        URLSession.shared.datatask(type: IncomeStatementsArray.self,
                                   url: Endpoints.incomeStatement(ticker: ticker.symbol, isAnnual: false).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    self.incomeStatementsQuarterly = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.notify(queue: .main) {
            completion?(completed)
        }
    }
    
    func getCashFlows(completion: ((Bool) -> ())? = nil) {
        let group = DispatchGroup()
        group.enter()
        var completed = false
        
        URLSession.shared.datatask(type: CashFlowsArray.self,
                                   url: Endpoints.cashFlow(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.cashFlowsAnnual = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.enter()
        URLSession.shared.datatask(type: CashFlowsArray.self,
                                   url: Endpoints.cashFlow(ticker: ticker.symbol, isAnnual: false).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.cashFlowsQuarterly = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.notify(queue: .main) {
            completion?(completed)
        }
    }
    
    func load(completion: @escaping () -> ()) {
        let group = DispatchGroup()
        group.enter()
        getKeyMetrics() { completed in
            group.leave()
        }
        
        group.enter()
        getIncomeStatement() { _ in
            group.leave()
        }
        
        group.enter()
        getBalanceSheet() { _ in
            group.leave()
        }
        
        group.enter()
        getCashFlows() { _ in
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}
