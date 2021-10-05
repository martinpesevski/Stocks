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
        let group = DispatchGroup()
        group.enter()
        var completed = false
    
        URLSession.shared.datatask(type: [KeyMetrics].self,
                                   url: Endpoints.keyMetrics(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.keyMetricsAnnual = data
                                    self.calculateIntrinsicValue()
                                    completed = error == nil
                                    group.leave()
        }
        
        group.enter()
        URLSession.shared.datatask(type: [KeyMetrics].self,
                                   url: Endpoints.keyMetrics(ticker: ticker.symbol, isAnnual: false).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.keyMetricsQuarterly = data
                                    self.calculateIntrinsicValue()
                                    completed = error == nil
                                    group.leave()
        }
        
        group.notify(queue: .main) {
            completion?(completed)
        }
    }
    
    func getFinancialRatios(completion: ((Bool) -> ())? = nil) {
        let group = DispatchGroup()
        group.enter()
        var completed = false
        URLSession.shared.datatask(type: [FinancialRatios].self,
                                   url: Endpoints.financialRatios(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.financialRatiosAnnual = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.enter()
        URLSession.shared.datatask(type: [FinancialRatios].self,
                                   url: Endpoints.financialRatios(ticker: ticker.symbol, isAnnual: false).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.financialRatiosQuarterly = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.notify(queue: .main) {
            completion?(completed)
        }
    }
    
    func getBalanceSheet(completion: ((Bool) -> ())? = nil) {
        let group = DispatchGroup()
        group.enter()
        var completed = false
        URLSession.shared.datatask(type: [BalanceSheet].self,
                                   url: Endpoints.balanceSheet(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.balanceSheetsAnnual = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.enter()
        URLSession.shared.datatask(type: [BalanceSheet].self,
                                   url: Endpoints.balanceSheet(ticker: ticker.symbol, isAnnual: false).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.balanceSheetsQuarterly = data
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
        
        URLSession.shared.datatask(type: [IncomeStatement].self,
                                   url: Endpoints.incomeStatement(ticker: ticker.symbol, isAnnual: true).url) {
                                    [weak self] data, response, error in
                                    guard let self = self, let data = data else {
                                        group.leave()
                                        return }
                                    
                                    self.incomeStatementsAnnual = data
                                    completed = error == nil
                                    group.leave()
        }
        
        group.enter()
        URLSession.shared.datatask(type: [IncomeStatement].self,
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
        
        URLSession.shared.datatask(type: [CashFlow].self,
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
        URLSession.shared.datatask(type: [CashFlow].self,
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
        getKeyMetrics() { _ in
            group.leave()
        }
        
        group.enter()
        getFinancialRatios() { _ in
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
