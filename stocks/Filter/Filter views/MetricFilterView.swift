//
//  MetricFilterView.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import UIKit

enum MetricFilterPeriod: String, Codable {
    case lastQuarter = "Last quarter growth"
    case quarterOverQuarter = "Quarter over quarter growth"
    case last5Years = "Last 5 years growth per year"
}

enum MetricFilterCompareSign: String, Codable {
    case greaterThan = ">"
    case lessThan = "<"
}

protocol MetricFilterViewDelegate: AnyObject {
    func didChangeSelectionMetric(view: MetricFilterView, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String))
}

class MetricFilterView: FilterView {
    var metricFilter: MetricFilter
    weak var metricViewDelegate: MetricFilterViewDelegate?
    var isExpanded: Bool = false
    
    override func onSelectedChanged(_ selected: Bool) {
        if selected {
            metricFilter.period = metricFilter.period
            metricFilter.compareSign = metricFilter.compareSign
            metricFilter.value = metricFilter.value
            periodPicker.selectSegmentWithTitle(metricFilter.period?.rawValue)
            comparer.selectSegmentWithTitle(metricFilter.compareSign?.rawValue)
            percentagePicker.selectSegmentWithTitle(metricFilter.value)
            valuePicker.selectSegmentWithTitle(metricFilter.value)
            isExpanded = true
            animateSelected()
            animateInOut()
        } else {
            periodPicker.selectedSegmentIndex = UISegmentedControl.noSegment
            comparer.selectedSegmentIndex = UISegmentedControl.noSegment
            percentagePicker.selectedSegmentIndex = UISegmentedControl.noSegment
            valuePicker.selectedSegmentIndex = UISegmentedControl.noSegment
            layer.borderWidth = 0
            isExpanded = false
            explanation.isHidden = true
            metricFilter.period = nil
            metricFilter.compareSign = nil
            metricFilter.value = nil
            animateInOut()
        }
    }
    
    lazy var periodPicker: UISegmentedControl = {
        let seg = UISegmentedControl(items: [MetricFilterPeriod.lastQuarter.rawValue, MetricFilterPeriod.quarterOverQuarter.rawValue, MetricFilterPeriod.last5Years.rawValue])
        seg.addTarget(self, action: #selector(onValueChange(sender:)), for: .valueChanged)
        seg.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return seg
    }()
    lazy var comparer: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["<", ">"])
        seg.addTarget(self, action: #selector(onValueChange(sender:)), for: .valueChanged)
        seg.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        return seg
    }()
    lazy var percentagePicker: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["0%","5%", "10%", "15%", "20%", "25%", "30%"])
        seg.addTarget(self, action: #selector(onValueChange(sender:)), for: .valueChanged)
        seg.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return seg
    }()
    
    lazy var valuePicker: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["0","0.5", "1", "1.5", "2", "3", "5", "10"])
        seg.addTarget(self, action: #selector(onValueChange(sender:)), for: .valueChanged)
        seg.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return seg
    }()

    lazy var filterOptionsView: UIStackView = {
        let stack = UIStackView()
        
        switch metricFilter.associatedValueMetric.filterType {
        case .percentageGrowth:
            stack.addArrangedSubview(periodPicker)
            stack.addArrangedSubview(comparer)
            stack.addArrangedSubview(percentagePicker)
            percentagePicker.snp.makeConstraints { make in make.width.equalToSuperview() }
        case .metric:
            stack.addArrangedSubview(comparer)
            stack.addArrangedSubview(valuePicker)
            valuePicker.snp.makeConstraints { make in make.width.equalToSuperview() }
        case .none: break
        }
        
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    init(filter: MetricFilter, delegate: MetricFilterViewDelegate? = nil) {
        self.metricFilter = filter
        self.metricViewDelegate = delegate
        super.init(filter: filter, delegate: nil)
        
        accessoryType = .downArrow
        verticalContent.addArrangedSubview(filterOptionsView)
        
        filterOptionsView.isHidden = true
        explanation.isHidden = true
    }
    
    override func onTap() {
        isExpanded = !isExpanded
        
        animateInOut()
    }
    
    func animateInOut() {
        if isExpanded {
            self.filterOptionsView.alpha = 0
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self = self else { return }
                self.filterOptionsView.isHidden = !self.isExpanded
            } completion: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.15) {
                    self.filterOptionsView.alpha = 1
                }
                self.accessoryType = .upArrow
            }
        } else {
            UIView.animate(withDuration: 0.15) { [weak self] in
                guard let self = self else { return }
                self.filterOptionsView.alpha = 0
            } completion: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.2) {
                    self.filterOptionsView.isHidden = !self.isExpanded
                }
                self.accessoryType = .downArrow
            }
        }
    }

    
    @objc func onValueChange(sender: UISegmentedControl) {
        if sender == periodPicker {
            guard let title = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
            metricFilter.period = MetricFilterPeriod.init(rawValue: title)
        } else if sender == comparer {
            guard let title = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
            metricFilter.compareSign = MetricFilterCompareSign.init(rawValue: title)
        } else if sender == percentagePicker {
            metricFilter.value = sender.titleForSegment(at: sender.selectedSegmentIndex)
        } else if sender == valuePicker {
            metricFilter.value = sender.titleForSegment(at: sender.selectedSegmentIndex)
        }
        
        callDelegateIfNeeded()
    }
    
    func callDelegateIfNeeded() {
        switch metricFilter.associatedValueMetric.filterType {
        case .percentageGrowth:
            if let period = metricFilter.period, let compareSign = metricFilter.compareSign, let value = metricFilter.value {
                explanation.text = period.rawValue + " " + compareSign.rawValue + " " + value
                animateSelected()
                
                metricViewDelegate?.didChangeSelectionMetric(view: self, filters: (period: period, compareSign: compareSign, value: value))
            }
        case .metric:
            if let compareSign = metricFilter.compareSign, let value = metricFilter.value {
                explanation.text = compareSign.rawValue + " " + value
                animateSelected()
                
                metricViewDelegate?.didChangeSelectionMetric(view: self, filters: (period: nil, compareSign: compareSign, value: value))
            }
        case .none: break
        }
    }
    
    func animateSelected() {
        explanation.alpha = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.explanation.isHidden = false
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.explanation.alpha = 1
        }
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
