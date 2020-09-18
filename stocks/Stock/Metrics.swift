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
}

protocol MetricType {
    var text: String { get }
    var suffixType: MetricSuffixType { get }
}

struct AnyMetricType: MetricType, Codable, Equatable {
    var text: String
    var suffixType: MetricSuffixType
    
    init(_ base: MetricType) {
        self.text = base.text
        self.suffixType = base.suffixType
    }
}

protocol Financial {
    var date: String { get }
    var symbol: String { get }
    var metrics: [AnyMetric] { get }
}

struct AnyFinancial: Financial, Codable {
    var date: String
    var symbol: String
    var metrics: [AnyMetric]

    init(_ base: Financial) {
        self.date = base.date
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

    func percentageIncrease(metric: Metric) -> [Double] {
        let financials = sorted(by: { (first, second) -> Bool in
            return first.date < second.date
        })

        var mapped: [Double] = []
        var previousValue: Double = 0
        for financial in financials {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                let value = mtc.doubleValue
                let percentage = previousValue == 0 ? 0 :
                    previousValue < 0 ? ((previousValue - value) / previousValue) * 100 :
                    (-(previousValue - value) / previousValue) * 100
                previousValue = value
                mapped.append(percentage)
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
