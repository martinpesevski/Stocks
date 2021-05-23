//
//  MetricFilter.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import Foundation

enum MetricFilter: TitleDescription, Equatable, Codable {
    case incomeStatement(metric: AnyMetricType)
    case balanceSheet(metric: AnyMetricType)
    case cashFlows(metric: AnyMetricType)
    case financialRatios(metric: AnyMetricType)
    
    var title: String {
        switch self {
        case .incomeStatement(let metric): return "\(metric.text)"
        case .balanceSheet(let metric): return "\(metric.text)"
        case .cashFlows(let metric): return "\(metric.text)"
        case .financialRatios(let metric): return "\(metric.text)"
        }
    }

    var explanation: String {
        return ""
    }
    
    // Codable
    private enum CodingKeys: String, CodingKey { case incomeStatement, balanceSheet, cashFlows, financialRatios }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(AnyMetricType.self, forKey: .incomeStatement) {
            self = .incomeStatement(metric: value)
        } else  if let value = try? container.decode(AnyMetricType.self, forKey: .balanceSheet) {
            self = .balanceSheet(metric: value)
        } else  if let value = try? container.decode(AnyMetricType.self, forKey: .cashFlows) {
            self = .cashFlows(metric: value)
        } else if let value = try? container.decode(AnyMetricType.self, forKey: .financialRatios) {
            self = .financialRatios(metric: value)
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .incomeStatement(let metric): try container.encode(metric, forKey: .incomeStatement)
        case .balanceSheet(let metric): try container.encode(metric, forKey: .balanceSheet)
        case .cashFlows(let metric): try container.encode(metric, forKey: .cashFlows)
        case .financialRatios(let metric): try container.encode(metric, forKey: .financialRatios)
        }
    }
}
