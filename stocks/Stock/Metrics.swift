//
//  Metrics.swift
//  Stocker
//
//  Created by Martin Peshevski on 9/12/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

enum MetricSuffixType: String, Codable {
    case percentage
    case money
    case none
}

enum MetricFilterType: String, Codable {
    case percentageGrowth
    case metric
    case none
}

enum FiscalPeriod: String, Codable {
    case annual = "FY"
    case firstQuarter = "Q1"
    case secondQuarter = "Q2"
    case thirdQuarter = "Q3"
    case fourthQuarter = "Q4"
}

protocol Metric {
    var text: String { get }
    var stringValue: String { get }
    var doubleValue: Double { get }
    var metricType: AnyMetricType? { get }
    var metricSuffixType: MetricSuffixType { get }
}

extension Metric {
    var text: String {
        metricType?.text ?? ""
    }
    
    var metricSuffixType: MetricSuffixType {
        metricType?.suffixType ?? .none
    }
}

struct AnyMetric: Metric, Codable, Equatable {
    var text: String
    var stringValue: String
    var doubleValue: Double
    var metricType: AnyMetricType?
    var metricSuffixType: MetricSuffixType

    init(_ base: Metric) {
        self.text = base.text
        self.stringValue = base.stringValue
        self.doubleValue = base.doubleValue
        self.metricType = base.metricType
        self.metricSuffixType = base.metricSuffixType
    }
    
    init(text: String, doubleValue: Double, metricType: AnyMetricType, metricSuffixType: MetricSuffixType) {
        self.text = text
        self.doubleValue = doubleValue
        self.stringValue = "\(doubleValue)"
        self.metricType = metricType
        self.metricSuffixType = metricSuffixType
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.text == rhs.text && lhs.metricType == rhs.metricType
    }
}

protocol MetricType {
    var text: String { get }
    var suffixType: MetricSuffixType { get }
    var filterType: MetricFilterType { get }
}

struct AnyMetricType: MetricType, Codable, Equatable {
    var text: String
    var suffixType: MetricSuffixType
    var filterType: MetricFilterType

    init(_ base: MetricType) {
        self.text = base.text
        self.suffixType = base.suffixType
        self.filterType = base.filterType
    }
    
    init(text: String, suffixType: MetricSuffixType, filterType: MetricFilterType) {
        self.text = text
        self.suffixType = suffixType
        self.filterType = filterType
    }
}

protocol Financial {
    var date: String { get }
    var period: FiscalPeriod { get }
    var symbol: String { get }
    var metrics: [AnyMetric] { get }
}

extension Financial {
    func containsMetricType(_ type: AnyMetricType, forPeriod: MetricFilterPeriod?) -> Bool {
        guard let forPeriod = forPeriod else { return false }
        var isValidPeriod = false
        switch forPeriod {
        case .lastQuarter, .quarterOverQuarter:
            switch period {
            case .firstQuarter, .secondQuarter, .thirdQuarter, .fourthQuarter:
                isValidPeriod = true
            default:
                isValidPeriod = false
            }
        case .last5Years:
            switch period {
            case .annual:
                isValidPeriod = true
            default:
                isValidPeriod = false
            }
        }
        return metrics.map { $0.metricType } .contains(type) && isValidPeriod
    }
    
    func isValidPeriod(metricFilter: MetricFilter, startingFinancial: AnyFinancial) -> Bool {
        if !containsMetricType(metricFilter.associatedValueMetric, forPeriod: metricFilter.period) {
            return false
        }
        
        if let index = metrics.map({ $0.metricType }).firstIndex(of:metricFilter.associatedValueMetric),
           let metric = metrics[safe: index],
           let olderIndex = startingFinancial.metrics.map({ $0.metricType }).firstIndex(of:metricFilter.associatedValueMetric),
           let olderMetric = startingFinancial.metrics[safe: olderIndex] {
            guard let metricFilterValue = metricFilter.doubleValue else { return false }
            
            let previousValue = olderMetric.doubleValue
            let value = metric.doubleValue
            
            switch metricFilter.compareSign {
            case .greaterThan:
                switch metric.metricSuffixType {
                case .money:

                    let olderIndexDouble = (Double(olderIndex) == 0 ? 1 : Double(olderIndex))
                    let positivePercentage = (((previousValue - value) / previousValue) * 100) / (metricFilter.period == .last5Years ? olderIndexDouble : 1)
                    let negativePercentage = ((-(previousValue - value) / previousValue) * 100) / (metricFilter.period == .last5Years ? olderIndexDouble : 1)
                    
                    let percentage = previousValue == 0 ? 0 : (previousValue < 0 ? positivePercentage : negativePercentage )
                    
                    return percentage > metricFilterValue
                case .percentage:
                    return value - previousValue > metricFilterValue / 100
                case .none:
                    return value > metricFilterValue
                }
            case .lessThan:
                switch metric.metricSuffixType {
                case .money:

                    let percentage = previousValue == 0 ? 0 :
                        previousValue < 0 ? ((previousValue - value) / previousValue) * 100 :
                        (-(previousValue - value) / previousValue) * 100
                    return percentage < metricFilterValue
                case .percentage:
                    return value - previousValue < metricFilterValue / 100
                case .none:
                    return value < metricFilterValue
                }
            case .none:
                return false
            }
        }
        return false
    }
}

struct AnyFinancial: Financial, Codable {
    var date: String
    var period: FiscalPeriod
    var symbol: String
    var metrics: [AnyMetric]

    init(_ base: Financial) {
        self.date = base.date
        self.period = base.period
        self.symbol = base.symbol
        self.metrics = base.metrics
    }
}

extension Collection where Iterator.Element: Financial {
    var symbol: String {
        self[safe: 0 as! Self.Index]?.symbol ?? ""
    }

    func latestValue(metric: Metric) -> String {
        guard let financial = sorted(by: { (first, second) -> Bool in
            return first.date > second.date
        }).first else { return "" }
        
        for mtc in financial.metrics where mtc.metricType?.text == metric.text {
            return mtc.stringValue
        }
        
        return ""
    }
    
    var previousQuarter: Financial? {
        self[safe: 1 as! Self.Index]
    }
    
    var fivePeriodsBack: Financial? {
        self[safe: Swift.min(count, 4) as! Self.Index]
    }
    
    func isEligibleForFilter(metricFilter: MetricFilter) -> Bool {
        switch metricFilter.period {
        case .lastQuarter:
            guard let previousQuarter = previousQuarter, let first = self[safe: 0 as! Self.Index] else { return false }
            return isEligibile(metricFilter: metricFilter, newFinancial: first, oldFinancial: previousQuarter)
        case .quarterOverQuarter, .last5Years:
            guard let fivePeriodsBack = fivePeriodsBack, let first = self[safe: 0 as! Self.Index] else { return false }
            return isEligibile(metricFilter: metricFilter, newFinancial: first, oldFinancial: fivePeriodsBack)
        case .none:
            return false
        }
    }
    
    private func isEligibile(metricFilter: MetricFilter, newFinancial: Financial, oldFinancial: Financial) -> Bool {
        if !newFinancial.containsMetricType(metricFilter.associatedValueMetric, forPeriod: metricFilter.period) {
            return false
        }
        
        if let index = newFinancial.metrics.map({ $0.metricType }).firstIndex(of:metricFilter.associatedValueMetric),
           (newFinancial.metrics[safe: index] != nil),
           let olderIndex = oldFinancial.metrics.map({ $0.metricType }).firstIndex(of:metricFilter.associatedValueMetric),
           (oldFinancial.metrics[safe: olderIndex] != nil) {
            return metricFilter.doubleValue != nil
        }
        return false
    }
    
    func filterPreviousQuarter(metricFilter: MetricFilter) -> Bool {
        if let previousQuarter = previousQuarter, let first = self[safe: 0 as! Self.Index] {
           return first.isValidPeriod(metricFilter: metricFilter, startingFinancial: AnyFinancial(previousQuarter))
        }
        
        return false
    }
    
    func filterFivePeriodsBack(metricFilter: MetricFilter) -> Bool {
        if let fivePeriodsBack = fivePeriodsBack, let first = self[safe: 0 as! Self.Index] {
            return first.isValidPeriod(metricFilter: metricFilter, startingFinancial: AnyFinancial(fivePeriodsBack))
        }
        
        return false
    }
    
    func periodicValues(metric: Metric) -> [Double] {
        let financials = sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        })
        
        var mapped: [Double] = []
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(mtc.doubleValue)
            }
        }

        return mapped
    }

    func percentageIncrease(metric: Metric) -> [PeriodicFinancialModel] {
        let financials = sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        })

        var mapped: [PeriodicFinancialModel] = []
        var previousValue: Double = 0
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                let value = mtc.doubleValue
                let percentage = previousValue == 0 ? 0 :
                    previousValue < 0 ? ((previousValue - value) / previousValue) * 100 :
                    (-(previousValue - value) / previousValue) * 100
                previousValue = value
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.doubleValue, stringValue: mtc.stringValue, percentChange: percentage))
            }
        }

        return mapped.reversed()
    }
    
    func metric(metricType: MetricType) -> AnyMetric? {
        for statement in self {
            if let item = statement.metrics.filter({ $0.text == metricType.text }).first {
                return item
            }
        }
        return nil
    }
}
