//
//  IntrinsicValue.swift
//  stocks
//
//  Created by Martin Peshevski on 3/25/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

struct IntrinsicValue {
    enum DiscountRate: Float {
        case low = 0.06
        case medium = 0.075
        case high = 0.09
    }

    var stockPrice: Float
    var discountRates: [Float] = []
    var discountedCashFlows: [Float] = []
    var regularCashFlows: [Float] = []
    var growthRate: Float = 0
    var value: Float = 0

    init(price: Float, cashFlow ocf: Float, growthRate: Float, discountRate: DiscountRate) {
        stockPrice = price
        discountRates = calculateDiscountRates(discountRate)
        regularCashFlows = calculateFutureCashFlows(cashFlow: ocf, growth: growthRate)
        discountedCashFlows = calculateDiscountedCashFlows(cashFlows: regularCashFlows, discountRates: discountRates)
        self.growthRate = growthRate

        value = discountedCashFlows.reduce(0, +)
    }

    func calculateDiscountRates(_ originalDiscountRate: DiscountRate) -> [Float] {
        var discountRate = 1 + originalDiscountRate.rawValue
        var rates: [Float] = []
        for i in 1...10 {
            discountRate = i == 1 ? discountRate : discountRate * (1 + originalDiscountRate.rawValue)
            rates.append(discountRate)
        }

        return rates
    }

    func calculateFutureCashFlows(cashFlow: Float, growth: Float) -> [Float] {
        var cashFlows: [Float] = []
        for i in 0..<10 {
            let previousCashFlow = cashFlows.isEmpty ? abs(cashFlow) : abs(cashFlows[i - 1])
            cashFlows.append(previousCashFlow * (1 + growth))
        }
        return cashFlows
    }

    func calculateDiscountedCashFlows(cashFlows: [Float], discountRates: [Float]) -> [Float] {
        var discountedCashFlows: [Float] = []
        for i in 0..<10 {
            let cashFlow = cashFlows[i] / discountRates[i]
            discountedCashFlows.append(cashFlow)
        }
        return discountedCashFlows
    }

    var discount: Float {
        return ((value - stockPrice) / value) * 100
    }

    var color: UIColor {
        if value * 0.3 > stockPrice { return .green }
        if value > stockPrice { return .systemYellow }
        return .red
    }
}
