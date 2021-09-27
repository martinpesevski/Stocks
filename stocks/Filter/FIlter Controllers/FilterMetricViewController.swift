//
//  FilterMetricViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import Foundation

import UIKit

protocol FilterMetricDelegate: AnyObject {
    func didChangeSelection(selectedFilters: [MetricFilter])
}

class FilterMetricViewController: FilterPageViewController, MetricFilterViewDelegate, SelectedFilterViewDelegate {
    weak var delegate: FilterMetricDelegate?
    var selectedFilters: [MetricFilter] = []

    lazy var incomeStatementViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []

        for metric in IncomeStatementMetricType.allCases where metric.filterType != .none {
            var metricView = MetricFilterView(filter: MetricFilter(associatedValueMetric: AnyMetricType(metric), period: nil, compareSign: nil, value: nil), delegate: self)

            for (index, filter) in selectedFilters.enumerated() {
                if filter.associatedValueMetric == AnyMetricType(metric) {
                    metricView = MetricFilterView(filter: filter, delegate: self)
                }
            }

            metricView.isSelected = selectedFilters.map { $0.associatedValueMetric }.contains(metricView.metricFilter.associatedValueMetric)
            arr.append(metricView)
        }
        return arr
    }()
    
    lazy var balanceSheetViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in BalanceSheetMetricType.allCases where metric.filterType != .none {
            var metricView = MetricFilterView(filter: MetricFilter(associatedValueMetric: AnyMetricType(metric), period: nil, compareSign: nil, value: nil), delegate: self)

            for (index, filter) in selectedFilters.enumerated() {
                if filter.associatedValueMetric == AnyMetricType(metric) {
                    metricView = MetricFilterView(filter: filter, delegate: self)
                }
            }
            metricView.isSelected = selectedFilters.map { $0.associatedValueMetric }.contains(metricView.metricFilter.associatedValueMetric)
            arr.append(metricView)
        }
        return arr
    }()
    
    lazy var cashFlowViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in CashFlowMetricType.allCases where metric.filterType != .none {
            var metricView = MetricFilterView(filter: MetricFilter(associatedValueMetric: AnyMetricType(metric), period: nil, compareSign: nil, value: nil), delegate: self)

            for (index, filter) in selectedFilters.enumerated() {
                if filter.associatedValueMetric == AnyMetricType(metric) {
                    metricView = MetricFilterView(filter: filter, delegate: self)
                }
            }

            metricView.isSelected = selectedFilters.map { $0.associatedValueMetric }.contains(metricView.metricFilter.associatedValueMetric)
            arr.append(metricView)
        }
        return arr
    }()
    
    lazy var financialRatiosViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in FinancialRatioMetricType.allCases where metric.filterType != .none {
            var metricView = MetricFilterView(filter: MetricFilter(associatedValueMetric: AnyMetricType(metric), period: nil, compareSign: nil, value: nil), delegate: self)

            for (index, filter) in selectedFilters.enumerated() {
                if filter.associatedValueMetric == AnyMetricType(metric) {
                    metricView = MetricFilterView(filter: filter, delegate: self)
                }
            }

            metricView.isSelected = selectedFilters.map { $0.associatedValueMetric }.contains(metricView.metricFilter.associatedValueMetric)
            arr.append(metricView)
        }
        return arr
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Income \nstatement", "Balance \nsheet", "Cash \nflow", "Financial \nratios"])
        s.snp.makeConstraints { make in make.height.equalTo(50) }
        s.selectedSegmentIndex = 0
        s.addTarget(self, action: #selector(onSegmentChange), for: .valueChanged)
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "Create a custom screener"
        button.setTitle("Save", for: .normal)

        content.addArrangedSubview(segmentedControl)
        content.setCustomSpacing(20, after: segmentedControl)
        
        for view in incomeStatementViews {
            content.addArrangedSubview(view)
        }
        
        setupSelectedViews()

        content.addArrangedSubview(UIView())
    }
    
    func setupSelectedViews() {
        for filter in selectedFilters {
            let selectedFilterView = SelectedFilterView(filter: filter, text: filter.text, delegate: self)
            content.stockStack.insertArrangedSubview(selectedFilterView, at: 2)
        }
    }
    
    func didChangeSelectionMetric(view: MetricFilterView, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String)) {
        var periodText = ""
        if let period = filters.period?.rawValue { periodText = period + " " }
        let text = view.metricFilter.associatedValueMetric.text + " " + periodText + filters.compareSign.rawValue + " " + filters.value
        let filterV = SelectedFilterView(filter: view.metricFilter, text: text, delegate: self)
        
        if !selectedFilters.contains(view.metricFilter) {
            selectedFilters.append(view.metricFilter)
            content.stockStack.insertArrangedSubview(filterV, at: 2)
        } else {
            content.stockStack.arrangedSubviews.forEach {
                if ($0 as? SelectedFilterView)?.filter.associatedValueMetric == filterV.filter.associatedValueMetric {
                    if let index = content.stockStack.arrangedSubviews.firstIndex(of: $0) {
                        (content.stockStack.arrangedSubviews[index] as? SelectedFilterView)?.titleLabel.text = text
                    }
                }
            }
        }
    }
    
    func onClearSelected(filter: MetricFilter) {
        if let filterIndex = selectedFilters.firstIndex(of: filter) { selectedFilters.remove(at: filterIndex) }

        self.incomeStatementViews.forEach { if filter == $0.metricFilter { $0.isSelected = false } }
        self.balanceSheetViews.forEach { if filter == $0.metricFilter { $0.isSelected = false } }
        self.cashFlowViews.forEach { if filter == $0.metricFilter { $0.isSelected = false } }
        self.financialRatiosViews.forEach { if filter == $0.metricFilter { $0.isSelected = false } }
    }
    
    @objc func onSegmentChange(sender: UISegmentedControl)
    {
        for view in content.stockStack.arrangedSubviews where view is FilterView {
            view.removeFromSuperview()
        }
        switch sender.selectedSegmentIndex {
        case 0: incomeStatementViews.forEach { content.addArrangedSubview($0) }
        case 1: balanceSheetViews.forEach { content.addArrangedSubview($0) }
        case 2: cashFlowViews.forEach { content.addArrangedSubview($0) }
        case 3: financialRatiosViews.forEach { content.addArrangedSubview($0) }
        default:
            return
        }
    }
    
    override func onDone() {
        delegate?.didChangeSelection(selectedFilters: selectedFilters)
        super.onDone()
    }
}
