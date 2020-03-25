//
//  stocksTests.swift
//  stocksTests
//
//  Created by Martin Peshevski on 2/18/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Quick
import Nimble
@testable import stocks

class StockSpec: QuickSpec {
    override func spec() {
        var stock: Stock!
        var keyMetrics: KeyMetricsArray?
        var growthMetrics: GrowthMetricsArray?
        var quote: Quote?

        beforeEach {
            let bundle = Bundle(for: type(of: self))
            let ticker = Ticker(symbol: "AAPL", name: "Apple", price: 123.45, exchange: "NYSE")
            stock = Stock(ticker: ticker)

            guard let growthPath = bundle.path(forResource: "growth-metrics", ofType: "json"),
                let data = try? Data(contentsOf: URL(fileURLWithPath: growthPath), options: .mappedIfSafe) else { return }
            growthMetrics = DataParser.parseTJson(type: GrowthMetricsArray.self, data: data)

            guard let profilePath = bundle.path(forResource: "profile", ofType: "json"),
                let profileData = try? Data(contentsOf: URL(fileURLWithPath: profilePath), options: .mappedIfSafe) else { return }
            quote = DataParser.parseTJson(type: Quote.self, data: profileData)

            guard let keyMetricsPath = bundle.path(forResource: "key-metrics", ofType: "json"),
                let keyMetricsData = try? Data(contentsOf: URL(fileURLWithPath: keyMetricsPath), options: .mappedIfSafe) else { return }
            keyMetrics = DataParser.parseTJson(type: KeyMetricsArray.self, data: keyMetricsData)
        }

        describe("Ticker data") {
            it("sets the correct ticker data") {
                expect(stock.ticker.name).to(equal("Apple"))
            }
        }

        describe("Profile") {
            it("parses profile correctly") {
                expect(quote?.symbol).to(equal("AAPL"))
            }

            it("calculates stock market cap correctly") {
                stock.quote = quote
                expect(stock.marketCap).to(equal(.large))
            }
        }

        describe("Key metrics") {
            it("parses key metrics correctly") {
                expect(keyMetrics?.metrics?.count).to(equal(11))
            }

            it("calculates profitability correctly") {
                stock.keyMetricsOverTime = keyMetrics
                expect(stock.profitability).to(equal(.profitable))
            }
        }

        describe("Growth metrics") {
            it("parses growth metrics correctly") {
                expect(growthMetrics?.symbol).to(equal("AAPL"))
                expect(growthMetrics?.growth?.count).to(equal(11))
            }
        }

        describe("intrinsic value calculation") {
            beforeEach {
                stock.growthMetrics = growthMetrics?.growth
                stock.quote = quote
                stock.keyMetricsOverTime = keyMetrics
                stock.calculateIntrinsicValue()
            }

            it("calculates the correct future cash flows") {
                expect(stock.intrinsicValue?.regularCashFlows).to(equal([17.280752, 19.872864, 22.853792, 26.28186, 30.224138, 34.75776, 39.97142, 45.967133, 52.8622, 60.79153]))
            }

            it("calculates the correct discount rates") {
                expect(stock.intrinsicValue?.discountRates).to(equal([1.06, 1.1235999, 1.1910158, 1.2624767, 1.3382252, 1.4185187, 1.5036297, 1.5938474, 1.6894782, 1.7908467]))
            }

            it("calculates the correct OCF growth") {
                expect(keyMetrics?.averageOCFGrowth).to(equal(0.21050048))
            }

            it("calculates the correct discounted cash flows") {
                expect(stock.intrinsicValue?.discountedCashFlows).to(equal([16.302597, 17.686779, 19.188488, 20.8177, 22.58524, 24.502857, 26.583288, 28.84036, 31.28907, 33.94569]))
            }

            it("calculates the correct intrinsic value") {
                expect(stock.intrinsicValue?.value).to(equal(241.74205))
            }
        }
    }
}
