//
//  MetricFilter.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import Foundation

enum MetricFilter: TitleDescription, Equatable, Codable {
    case incomeStatement(metric: AnyMetricType, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String)?)
    case balanceSheet(metric: AnyMetricType, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String)?)
    case cashFlows(metric: AnyMetricType, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String)?)
    case financialRatios(metric: AnyMetricType, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String)?)
    
    static func == (lhs: MetricFilter, rhs: MetricFilter) -> Bool {
        return lhs.associatedValueMetric == rhs.associatedValueMetric
    }
    
    var title: String {
        return associatedValueMetric.text
    }

    var explanation: String {
        return ""
    }
    
    var associatedValueMetric: AnyMetricType {
        switch self {
        case .incomeStatement(metric: let metric, _): return metric;
        case .balanceSheet(metric: let metric, _): return metric;
        case .cashFlows(metric: let metric, _): return metric;
        case .financialRatios(metric: let metric, _): return metric;
        }
    }
    
    // Codable
    private enum CodingKeys: String, CodingKey { case incomeStatement, balanceSheet, cashFlows, financialRatios }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(AnyMetricType.self, forKey: .incomeStatement) {
            self = .incomeStatement(metric: value, filters: nil)
        } else  if let value = try? container.decode(AnyMetricType.self, forKey: .balanceSheet) {
            self = .balanceSheet(metric: value, filters: nil)
        } else  if let value = try? container.decode(AnyMetricType.self, forKey: .cashFlows) {
            self = .cashFlows(metric: value, filters: nil)
        } else if let value = try? container.decode(AnyMetricType.self, forKey: .financialRatios) {
            self = .financialRatios(metric: value, filters: nil)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .incomeStatement(let metric, _): try container.encode(metric, forKey: .incomeStatement)
        case .balanceSheet(let metric, _): try container.encode(metric, forKey: .balanceSheet)
        case .cashFlows(let metric, _): try container.encode(metric, forKey: .cashFlows)
        case .financialRatios(let metric, _): try container.encode(metric, forKey: .financialRatios)
        }
    }
}
