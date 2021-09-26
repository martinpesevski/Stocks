//
//  IntrinsicValue.swift
//  stocks
//
//  Created by Martin Peshevski on 3/25/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

struct IntrinsicValue {
    enum DiscountRate: Double {
        case low = 0.06
        case medium = 0.075
        case high = 0.09
        
        var percentageString: String {
            switch self {
            case .low: return "\(DiscountRate.low.rawValue * 100)%"
            case .medium: return "\(DiscountRate.medium.rawValue * 100)%"
            case .high: return "\(DiscountRate.high.rawValue * 100)%"
            }
        }
    }

    var stockPrice: Double
    var originalDiscountRate: DiscountRate {
        didSet {
            calculateValue()
        }
    }
    var growthRate: Double = 0 {
        didSet {
            calculateValue()
        }
    }
    var cashFlow: Double {
        didSet {
            calculateValue()
        }
    }
    var discountRates: [Double] = []
    var discountedCashFlows: [Double] = []
    var regularCashFlows: [Double] = []
    var value: Double = 0

    init(price: Double, cashFlow ocf: Double, growthRate: Double, discountRate: DiscountRate) {
        self.stockPrice = price
        self.originalDiscountRate = discountRate
        self.growthRate = growthRate
        self.cashFlow = ocf
        
        calculateValue()
    }
    
    mutating func calculateValue() {
//        discountRates = calculateDiscountRates(self.originalDiscountRate)
//        regularCashFlows = calculateFutureCashFlows(cashFlow: self.cashFlow, growth: self.growthRate)
//        discountedCashFlows = calculateDiscountedCashFlows(cashFlows: regularCashFlows, discountRates: discountRates)
//
//        value = discountedCashFlows.reduce(0, +)
        value = 100
    }

    func calculateDiscountRates(_ originalDiscountRate: DiscountRate) -> [Double] {
        var discountRate = 1 + originalDiscountRate.rawValue
        var rates: [Double] = []
        for i in 1...10 {
            discountRate = i == 1 ? discountRate : discountRate * (1 + originalDiscountRate.rawValue)
            rates.append(discountRate)
        }

        return rates
    }

    func calculateFutureCashFlows(cashFlow: Double, growth: Double) -> [Double] {
        var cashFlows: [Double] = []
        for i in 0..<10 {
            let previousCashFlow = cashFlows.isEmpty ? abs(cashFlow) : abs(cashFlows[i - 1])
            cashFlows.append(previousCashFlow * (1 + growth))
        }
        return cashFlows
    }

    func calculateDiscountedCashFlows(cashFlows: [Double], discountRates: [Double]) -> [Double] {
        var discountedCashFlows: [Double] = []
        for i in 0..<10 {
            let cashFlow = cashFlows[i] / discountRates[i]
            discountedCashFlows.append(cashFlow)
        }
        return discountedCashFlows
    }

    var discount: Double {
        return ((value - stockPrice) / value) * 100
    }

    var color: UIColor {
        if value * 0.3 > stockPrice { return .systemGreen }
        if value > stockPrice { return .systemYellow }
        return .systemRed
    }
}
