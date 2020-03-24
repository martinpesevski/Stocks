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
                stock.keyMetricsOverTime = keyMetrics?.metrics
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
                stock.keyMetricsOverTime = keyMetrics?.metrics
                stock.calculateIntrinsicValue()
            }

            it("calculates the correct intrinsic value") {
                expect(stock.intrinsicValue?.value).to(equal(400))
            }
        }
    }
}
