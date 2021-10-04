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

            guard let keyMetricsPath = bundle.path(forResource: "key-metrics-quarterly", ofType: "json"),
                let keyMetricsData = try? Data(contentsOf: URL(fileURLWithPath: keyMetricsPath), options: .mappedIfSafe) else { return }
            stock.keyMetricsQuarterly = DataParser.parseTJson(type: [KeyMetrics].self, data: keyMetricsData)
            
            guard let keyMetricsQPath = bundle.path(forResource: "key-metrics-annual", ofType: "json"),
                let keyMetricsQData = try? Data(contentsOf: URL(fileURLWithPath: keyMetricsQPath), options: .mappedIfSafe) else { return }
            stock.keyMetricsAnnual = DataParser.parseTJson(type: [KeyMetrics].self, data: keyMetricsQData)
            
            guard let incomeStatementsQPath = bundle.path(forResource: "income-statements-quarterly", ofType: "json"),
                let incomeStatementsQData = try? Data(contentsOf: URL(fileURLWithPath: incomeStatementsQPath), options: .mappedIfSafe) else { return }
            stock.incomeStatementsQuarterly = DataParser.parseTJson(type: [IncomeStatement].self, data: incomeStatementsQData)
            
            guard let incomeStatementsPath = bundle.path(forResource: "income-statements-annual", ofType: "json"),
                let incomeStatementsData = try? Data(contentsOf: URL(fileURLWithPath: incomeStatementsPath), options: .mappedIfSafe) else { return }
            stock.incomeStatementsAnnual = DataParser.parseTJson(type: [IncomeStatement].self, data: incomeStatementsData)
            
            guard let balanceSheetsQPath = bundle.path(forResource: "balance-sheets-quarterly", ofType: "json"),
                let balanceSheetsQData = try? Data(contentsOf: URL(fileURLWithPath: balanceSheetsQPath), options: .mappedIfSafe) else { return }
            stock.balanceSheetsQuarterly = DataParser.parseTJson(type: [BalanceSheet].self, data: balanceSheetsQData)
            
            guard let balanceSheetsPath = bundle.path(forResource: "balance-sheets-annual", ofType: "json"),
                let balanceSheetsData = try? Data(contentsOf: URL(fileURLWithPath: balanceSheetsPath), options: .mappedIfSafe) else { return }
            stock.balanceSheetsAnnual = DataParser.parseTJson(type: [BalanceSheet].self, data: balanceSheetsData)
            
            guard let cashFlowsQPath = bundle.path(forResource: "cash-flows-quarterly", ofType: "json"),
                let cashFlowsQData = try? Data(contentsOf: URL(fileURLWithPath: cashFlowsQPath), options: .mappedIfSafe) else { return }
            stock.cashFlowsQuarterly = DataParser.parseTJson(type: [CashFlow].self, data: cashFlowsQData)
            
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

            it("filters by greater than quarterly non-suffix metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].peRatio!).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "10")]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }

            it("greater than quarterly non-suffix metrics failed") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].peRatio!).metricType!, period: .lastQuarter, compareSign: .lessThan, value: "10")]
                expect(stock.isValid(filter: filter)).to(beFalse())
            }

            it("filters by greater than quarterly dollar metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare!).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "2%")]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }

            it("filters by less than quarterly dollar metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare!).metricType!, period: .lastQuarter, compareSign: .lessThan, value: "15%")]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }

            it("filters by greater than quarterly percent metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].roic!).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "2")]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }

            it("filters by greater than QoQ dollar metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare!).metricType!, period: .quarterOverQuarter, compareSign: .greaterThan, value: "7")]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }

            it("filters by greater than last 5 years dollar metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare!).metricType!, period: .last5Years, compareSign: .greaterThan, value: "10%")]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }
            
            it("filters by greater than last 5 years dollar metrics") {
                var filter = Stocker.Filter()
                filter.metricFilters = [MetricFilter(associatedValueMetric: AnyMetric(stock.cashFlowsAnnual![0].commonStockRepurchased).metricType!, period: .last5Years, compareSign: .lessThan, value: "0%")]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }

            it("multiple true metric filters") {
                var filter = Stocker.Filter()
                filter.metricFilters = [
                    MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare!).metricType!, period: .quarterOverQuarter, compareSign: .greaterThan, value: "3%"),
                    MetricFilter(associatedValueMetric: AnyMetric(stock.balanceSheetsAnnual![0].cashAndCashEquivalents).metricType!, period: .last5Years, compareSign: .greaterThan, value: "3%"),
                    MetricFilter(associatedValueMetric: AnyMetric(stock.incomeStatementsAnnual![0].grossProfit).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "10%")
                ]
                expect(stock.isValid(filter: filter)).to(beTrue())
            }

            it("multiple true metric filters, one failed") {
                var filter = Stocker.Filter()
                filter.metricFilters = [
                    MetricFilter(associatedValueMetric: AnyMetric(stock.keyMetricsQuarterly![0].netIncomePerShare!).metricType!, period: .quarterOverQuarter, compareSign: .greaterThan, value: "3%"),
                    MetricFilter(associatedValueMetric: AnyMetric(stock.balanceSheetsAnnual![0].commonStock).metricType!, period: .last5Years, compareSign: .lessThan, value: "5%"),
                    MetricFilter(associatedValueMetric: AnyMetric(stock.incomeStatementsAnnual![0].grossProfit).metricType!, period: .lastQuarter, compareSign: .greaterThan, value: "10%")
                ]
                expect(stock.isValid(filter: filter)).to(beFalse())
            }
            
            //TODO: nill values?
        }
        
        describe("Data Parsing") {
            it("parses data correctly") {
                expect(stock.incomeStatementsAnnual).toNot(beNil())
                expect(stock.balanceSheetsAnnual).toNot(beNil())
                expect(stock.cashFlowsAnnual).toNot(beNil())
                expect(stock.keyMetricsAnnual).toNot(beNil())
                expect(stock.cashFlowsQuarterly).toNot(beNil())
                expect(stock.incomeStatementsQuarterly).toNot(beNil())
                expect(stock.balanceSheetsQuarterly).toNot(beNil())
                expect(stock.keyMetricsQuarterly).toNot(beNil())
            }
        }

        describe("Key metrics") {
            it("parses key metrics correctly") {
                expect(stock.keyMetricsQuarterly?.count).to(equal(10))
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
