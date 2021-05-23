//
//  Filter.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

struct Filter: Equatable, Codable {
    var capFilters: [CapFilter] = []
    var profitabilityFilters: [ProfitabilityFilter] = []
    var sectorFilters: [SectorFilter] = []
    var metricFilters: [MetricFilter] = []

    var isEmpty: Bool {
        capFilters.isEmpty && profitabilityFilters.isEmpty && sectorFilters.isEmpty && metricFilters.isEmpty
    }
    
    func isValid(_ filter: Filter) -> Bool {
        guard !filter.isEmpty else { return true }
        
        for cap in filter.capFilters where !capFilters.contains(cap) {
            if !capFilters.isEmpty { return false }
        }
        
        for prof in filter.profitabilityFilters where !profitabilityFilters.contains(prof) {
            if !profitabilityFilters.isEmpty { return false }
        }
        
        for sector in filter.sectorFilters where !sectorFilters.contains(sector) {
            if !sectorFilters.isEmpty { return false }
        }
        
        for metric in filter.metricFilters where !metricFilters.contains(metric) {
            if !metricFilters.isEmpty { return false }
        }
        
        return true
    }
    
    mutating func add(_ filter: TitleDescription) {
        if let cap = filter as? CapFilter, !capFilters.contains(cap) {
            capFilters.append(cap)
        } else if let prof = filter as? ProfitabilityFilter, !profitabilityFilters.contains(prof) {
            profitabilityFilters.append(prof)
        }
    }
    
    var endpoints: [Endpoints]? {
        var array: [Endpoints] = []
        if !capFilters.isEmpty && !sectorFilters.isEmpty {
            for capFilter in capFilters {
                for sectorFilter in sectorFilters {
                    array.append(.stockScreener(sector: sectorFilter.queryString, marketCap: capFilter.queryString))
                }
            }
        } else if !capFilters.isEmpty && sectorFilters.isEmpty {
            for capFilter in capFilters {
                array.append(.stockScreener(sector: nil, marketCap: capFilter.queryString))
            }
        } else if !capFilters.isEmpty && sectorFilters.isEmpty {
            for sectorFilter in sectorFilters {
                array.append(.stockScreener(sector: sectorFilter.queryString, marketCap: nil))
            }
        } else {
            array.append(.stockScreener(sector: nil, marketCap: nil))
        }
        
        return array
    }
}

protocol TitleDescription {
    var title: String { get }
    var explanation: String { get }
}
