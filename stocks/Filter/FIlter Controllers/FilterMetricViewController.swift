//
//  FilterMetricViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import Foundation

import UIKit

protocol FilterMetricDelegate: class {
    func didChangeSelectionMetric(_ filter: MetricFilter, isSelected: Bool)
}

class FilterMetricViewController: FilterPageViewController, MetricFilterViewDelegate, SelectedFilterViewDelegate {
    weak var delegate: FilterMetricDelegate?
    var selectedFilters: [MetricFilterView] = []
    
    lazy var incomeStatementViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in IncomeStatementMetricType.allCases where metric.filterType != .none {
            arr.append(MetricFilterView(filter: .incomeStatement(metric: AnyMetricType(metric)), delegate: self))
        }
        return arr
    }()
    
    lazy var balanceSheetViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in BalanceSheetMetricType.allCases where metric.filterType != .none {
            arr.append(MetricFilterView(filter: .balanceSheet(metric: AnyMetricType(metric)), delegate: self))
        }
        return arr
    }()
    
    lazy var cashFlowViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in CashFlowMetricType.allCases where metric.filterType != .none {
            arr.append(MetricFilterView(filter: .cashFlows(metric: AnyMetricType(metric)), delegate: self))
        }
        return arr
    }()
    
    lazy var financialRatiosViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in FinancialRatioMetricType.allCases where metric.filterType != .none {
            arr.append(MetricFilterView(filter: .financialRatios(metric: AnyMetricType(metric)), delegate: self))
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
    
    func didChangeSelection(view: MetricFilterView, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String)) {
        var periodText = ""
        if let period = filters.period?.rawValue { periodText = period + " " }
        let text = view.metricFilter.associatedValue.text + " " + periodText + filters.compareSign.rawValue + " " + filters.value
        let filterV = SelectedFilterView(filter: view, text: text, delegate: self)
        
        if !selectedFilters.contains(view) {
            selectedFilters.append(view)
            content.stockStack.insertArrangedSubview(filterV, at: 2)
        } else {
            if let index = content.stockStack.arrangedSubviews.firstIndex(of: filterV) {
                (content.stockStack.arrangedSubviews[index] as? SelectedFilterView)?.titleLabel.text = text
            }
        }
    }
    
    func onClearSelected(filter: SelectedFilterView) {
        if let index = selectedFilters.firstIndex(of: filter.filterType) { selectedFilters.remove(at: index) }
        UIView.animate(withDuration: 0.2, animations: {
            filter.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                filter.isHidden = true
            } completion: { [weak self] _ in
                guard let self = self else { return }
                filter.removeFromSuperview()
                self.incomeStatementViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
                self.balanceSheetViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
                self.cashFlowViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
                self.financialRatiosViews.forEach { if filter.filterType == $0 { $0.isSelected = false } }
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
}
