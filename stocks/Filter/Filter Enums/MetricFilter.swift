//
//  MetricFilter.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import Foundation

enum MetricFilterTab {
    case incomeStatement
    case balanceSheet
    case cashFlows
    case financialRatios
}

struct MetricFilter: TitleDescription, Equatable, Codable {
    static func == (lhs: MetricFilter, rhs: MetricFilter) -> Bool {
        return lhs.associatedValueMetric == rhs.associatedValueMetric
    }
    
    var title: String {
        return associatedValueMetric.text
    }

    var explanation: String {
        return ""
    }
    
    var associatedValueMetric: AnyMetricType
    
    var period: MetricFilterPeriod?
    
    var compareSign: MetricFilterCompareSign?
    
    var value: String?
    
    var doubleValue: Double? {
        value?.digits.doubleValue
    }

    var text: String { associatedValueMetric.text + " " + (period?.rawValue ?? "") + (compareSign?.rawValue ?? "") + " " + (value ?? "") }
}
