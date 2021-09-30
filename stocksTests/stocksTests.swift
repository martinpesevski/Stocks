//
//  stocksTests.swift
//  stocksTests
//
//  Created by Martin Peshevski on 2/18/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Stocker

class StockSpec: QuickSpec {
    override func spec() {
        var stock: Stock!

        beforeEach {
            let bundle = Bundle(for: type(of: self))
            let ticker = Ticker(symbol: "AAPL", companyName: "Apple Inc.", marketCap: 2445808500736, sector: "Technology", beta: 1.201964999999999950119899949640966951847076416015625, price: 142.83, volume: 80582976)
            stock = Stock(ticker: ticker)

            guard let profilePath = bundle.path(forResource: "profile", ofType: "json"),
                let profileData = try? Data(contentsOf: URL(fileURLWithPath: profilePath), options: .mappedIfSafe) else { return }
            stock.quote = DataParser.parseTJson(type: Quote.self, data: profileData)

            guard let keyMetricsPath = bundle.path(forResource: "key-metrics", ofType: "json"),
                let keyMetricsData = try? Data(contentsOf: URL(fileURLWithPath: keyMetricsPath), options: .mappedIfSafe) else { return }
            stock.keyMetricsQuarterly = DataParser.parseTJson(type: [KeyMetrics].self, data: keyMetricsData)
            
            guard let incomeStatementsPath = bundle.path(forResource: "income-statements-annual", ofType: "json"),
                let incomeStatementsData = try? Data(contentsOf: URL(fileURLWithPath: incomeStatementsPath), options: .mappedIfSafe) else { return }
            stock.incomeStatementsAnnual = DataParser.parseTJson(type: [IncomeStatement].self, data: incomeStatementsData)
            
            guard let balanceSheetsPath = bundle.path(forResource: "balance-sheets-annual", ofType: "json"),
                let balanceSheetsData = try? Data(contentsOf: URL(fileURLWithPath: balanceSheetsPath), options: .mappedIfSafe) else { return }
            stock.balanceSheetsAnnual = DataParser.parseTJson(type: [BalanceSheet].self, data: balanceSheetsData)
            
            guard let cashFlowsPath = bundle.path(forResource: "cash-flows-annual", ofType: "json"),
                let cashFlowsData = try? Data(contentsOf: URL(fileURLWithPath: cashFlowsPath), options: .mappedIfSafe) else { return }
            stock.cashFlowsAnnual = DataParser.parseTJson(type: [CashFlow].self, data: cashFlowsData)
        }

        describe("Ticker data") {
            it("sets the correct ticker data") {
                expect(stock.ticker.companyName).to(equal("Apple Inc."))
            }
        }

        describe("Profile") {
            it("parses profile correctly") {
                expect(stock.quote?.symbol).to(equal("AAPL"))
            }

            it("calculates stock market cap correctly") {
                expect(stock.quote?.marketCap).to(equal(.large))
            }
        }
        
        describe("Filtering") {
            it("filters by profitability") {
                expect(stock.filter.profitabilityFilters).to(equal([ProfitabilityFilter.profitable]))
            }
            it("filters by marketCap") {
                expect(stock.filter.capFilters).to(equal([CapFilter.largeCap]))
            }
            it("filters by sector") {
                expect(stock.filter.sectorFilters).to(equal([SectorFilter.tech]))
            }
//            it("filters by greater than quarterly non-suffix metrics") {
//                var filter = Stocker.Filter()
//                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].peRatio).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "10", doubleValue: 10)]
//                expect(stock.isValid(filter: filter)).to(beTrue())
//            }
//
//            it("filters by greater than quarterly dollar metrics") {
//                var filter = Stocker.Filter()
//                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "2%", doubleValue: 2)]
//                expect(stock.isValid(filter: filter)).to(beTrue())
//            }
            
//            it("filters by less than quarterly dollar metrics") {
//                var filter = Stocker.Filter()
//                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare).metricType!, period: .lastQuarter, compareSign: .lessThan, value: "15%", doubleValue: 15)]
//                expect(stock.isValid(filter: filter)).to(beTrue())
//            }
            
//            it("filters by greater than quarterly percent metrics") {
//                var filter = Stocker.Filter()
//                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].roic).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "2", doubleValue: 2)]
//                expect(stock.isValid(filter: filter)).to(beTrue())
//            }
//
//            it("filters by greater than QoQ dollar metrics") {
//                var filter = Stocker.Filter()
//                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare).metricType!, period: .quarterOverQuarter, compareSign: .greaterThan, value: "7", doubleValue: 7)]
//                expect(stock.isValid(filter: filter)).to(beTrue())
//            }
            
            it("filters by greater than QoQ dollar metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare).metricType!, period: .quarterOverQuarter, compareSign: .greaterThan, value: "7", doubleValue: 7)]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }
            
            //TODO: negative growth, zero values, 5 year growth
        }
        
        describe("Data Parsing") {
            it("parses data correctly") {
                expect(stock.keyMetricsQuarterly).toNot(beNil())
                expect(stock.incomeStatementsAnnual).toNot(beNil())
                expect(stock.balanceSheetsAnnual).toNot(beNil())
                expect(stock.cashFlowsAnnual).toNot(beNil())
            }
        }

        describe("Key metrics") {
            it("parses key metrics correctly") {
                expect(stock.keyMetricsQuarterly?.count).to(equal(41))
            }

            it("calculates profitability correctly") {
                expect(stock.keyMetricsQuarterly?.profitability).to(equal(.profitable))
            }
        }

//        describe("intrinsic value calculation") {
//            beforeEach {
//                stock.growthMetrics = growthMetrics?.growth
//                stock.quote = quote
//                stock.keyMetricsAnnual = keyMetrics
//                stock.calculateIntrinsicValue()
//            }
//
//            it("calculates the correct future cash flows") {
//                expect(stock.intrinsicValue?.regularCashFlows).to(equal([17.280752, 19.872864, 22.853792, 26.28186, 30.224138, 34.75776, 39.97142, 45.967133, 52.8622, 60.79153]))
//            }
//
//            it("calculates the correct discount rates") {
//                expect(stock.intrinsicValue?.discountRates).to(equal([1.06, 1.1235999, 1.1910158, 1.2624767, 1.3382252, 1.4185187, 1.5036297, 1.5938474, 1.6894782, 1.7908467]))
//            }
//
//            it("calculates the correct OCF growth") {
//                expect(keyMetrics?.averageOCFGrowth).to(equal(0.21050048))
//            }
//
//            it("calculates the correct discounted cash flows") {
//                expect(stock.intrinsicValue?.discountedCashFlows).to(equal([16.302597, 17.686779, 19.188488, 20.8177, 22.58524, 24.502857, 26.583288, 28.84036, 31.28907, 33.94569]))
//            }
//
//            it("calculates the correct intrinsic value") {
//                expect(stock.intrinsicValue?.value).to(equal(241.74205))
//            }
//        }
    }
}
