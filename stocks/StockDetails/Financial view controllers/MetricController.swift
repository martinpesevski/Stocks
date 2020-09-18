//
//  MetricController.swift
//  Stocker
//
//  Created by Martin Peshevski on 9/13/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol MetricController {
    var annualFinancials: [AnyFinancial] { get set }
    var quarterlyFinancials: [AnyFinancial] { get set }
    
    var metricsAnnual: [AnyMetric] { get set }
    var metricsQuarterly: [AnyMetric] { get set }
}

class MetricViewController: StackViewController, MetricController, MetricKeyValueDelegate {
    var annualFinancials: [AnyFinancial]
    var quarterlyFinancials: [AnyFinancial]
    
    var metricsAnnual: [AnyMetric]
    var metricsQuarterly: [AnyMetric]
    
    init(annualFinancial: [AnyFinancial],
         quarterlyFinancial: [AnyFinancial],
         title: String)
    {
        self.annualFinancials = annualFinancial
        self.quarterlyFinancials = quarterlyFinancial
        
        self.metricsAnnual = annualFinancials[safe: 0]?.metrics ?? []
        self.metricsQuarterly = quarterlyFinancials[safe: 0]?.metrics ?? []
        super.init()
        
        titleView.text = annualFinancial.symbol
        subtitleView.text = title
        
        content.addArrangedSubview(picker)
        content.setCustomSpacing(25, after: picker)
        
        picker.addTarget(self, action: #selector(onPeriodChanged(sender:)), for: .valueChanged)
        
        setupAnnual()
    }
    
    @objc
    func onPeriodChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: setupAnnual()
        case 1: setupQuarterly()
        default: return
        }
    }
    
    func setupAnnual() {
        removeMetrics()
        for metric in metricsAnnual {
            let cell = MetricKeyValueView(metric: metric)
            cell.valueLabel.text = annualFinancials.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(annualFinancials.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    func setupQuarterly() {
        removeMetrics()
        for metric in metricsQuarterly {
            let cell = MetricKeyValueView(metric: metric)
            cell.valueLabel.text = quarterlyFinancials.latestValue(metric: metric).roundedWithAbbreviations
            cell.chart.setData(quarterlyFinancials.periodicValues(metric: metric))
            cell.delegate = self
            content.addArrangedSubview(cell)
        }
    }
    
    private func removeMetrics() {
        for view in content.stockStack.arrangedSubviews where
            (view != titleView && view != subtitleView && view != picker) {
                view.removeFromSuperview()
        }
    }
    
    func didSelectMetric(_ metric: Metric) {
        let mappedAnual: [PeriodicFinancialModel] = createPeriodicChange(financials: annualFinancials, metric: metric)
        let mappedQuarterly: [PeriodicFinancialModel] = createPeriodicChange(financials: quarterlyFinancials, metric: metric)
        
        let vc = PeriodicValueChangeViewController(ticker: quarterlyFinancials.symbol, metricType: metric, periodicChangeAnnual: mappedAnual, periodicChangeQuarterly: mappedQuarterly)
        show(vc, sender: self)
    }
    
    private func createPeriodicChange(financials: [AnyFinancial], metric: Metric) -> [PeriodicFinancialModel] {
        var mapped: [PeriodicFinancialModel] = []
        let percentages = financials.percentageIncrease(metric: metric)
        for (index, financial) in financials.enumerated() {
            for mtc in financial.metrics where mtc.metricType?.text == metric.text {
                mapped.append(PeriodicFinancialModel(period: financial.date, value: mtc.doubleValue, stringValue: mtc.stringValue, percentChange: percentages[index]))
            }
        }
        return mapped
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
