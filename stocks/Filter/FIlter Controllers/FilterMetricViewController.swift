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
    var selectedFilterviews: [MetricFilterView] = []
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

        content.addArrangedSubview(UIView())
    }
    
    func didChangeSelectionMetric(view: MetricFilterView, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String)) {
        var periodText = ""
        if let period = filters.period?.rawValue { periodText = period + " " }
        let text = view.metricFilter.associatedValueMetric.text + " " + periodText + filters.compareSign.rawValue + " " + filters.value
        let filterV = SelectedFilterView(filter: view, text: text, delegate: self)
        
        if !selectedFilterviews.contains(view) {
            selectedFilterviews.append(view)
            content.stockStack.insertArrangedSubview(filterV, at: 2)
            selectedFilters.append(view.metricFilter)
        } else {
            content.stockStack.arrangedSubviews.forEach {
                if ($0 as? SelectedFilterView)?.filterType.metricFilter.associatedValueMetric == filterV.filterType.metricFilter.associatedValueMetric {
                    if let index = content.stockStack.arrangedSubviews.firstIndex(of: $0) {
                        (content.stockStack.arrangedSubviews[index] as? SelectedFilterView)?.titleLabel.text = text
                    }
                }
            }
        }
    }
    
    func onClearSelected(filter: SelectedFilterView) {
        if let index = selectedFilterviews.firstIndex(of: filter.filterType) {
            selectedFilterviews.remove(at: index)
            if let filterIndex = selectedFilters.firstIndex(of: filter.filterType.metricFilter) { selectedFilters.remove(at: filterIndex) }
        }
        
        self.incomeStatementViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
        self.balanceSheetViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
        self.cashFlowViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
        self.financialRatiosViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
        
        UIView.animate(withDuration: 0.2, animations: {
            filter.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                filter.isHidden = true
            } completion: { _ in
                filter.removeFromSuperview()
            }
        })
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
