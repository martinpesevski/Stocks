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

class FilterMetricViewController: FilterPageViewController, MetricFilterViewDelegate {
    weak var delegate: FilterMetricDelegate?
    var selectedFilters: [MetricFilter]? {
        didSet {
            guard let filters = selectedFilters else { return }
            
            for metricView in incomeStatementViews {
                if filters.contains(metricView.metricFilter) { metricView.isSelected = true }
            }
        }
    }
    
    lazy var incomeStatementViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in IncomeStatementMetricType.allCases {
            arr.append(MetricFilterView(filter: .incomeStatement(metric: AnyMetricType(metric)), delegate: self))
        }
        return arr
    }()
    
    lazy var balanceSheetViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in BalanceSheetMetricType.allCases {
            arr.append(MetricFilterView(filter: .balanceSheet(metric: AnyMetricType(metric)), delegate: self))
        }
        return arr
    }()
    
    lazy var cashFlowViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in CashFlowMetricType.allCases {
            arr.append(MetricFilterView(filter: .cashFlows(metric: AnyMetricType(metric)), delegate: self))
        }
        return arr
    }()
    
    lazy var financialRatiosViews: [MetricFilterView] = {
        var arr: [MetricFilterView] = []
        for metric in FinancialRatioMetricType.allCases {
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
    
    func didChangeSelection(view: MetricFilterView, isSelected: Bool) {
        delegate?.didChangeSelectionMetric(view.metricFilter, isSelected: isSelected)
    }
    
    @objc func onSegmentChange(sender: UISegmentedControl)
    {
        for view in content.stockStack.arrangedSubviews where view is FilterView{
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
