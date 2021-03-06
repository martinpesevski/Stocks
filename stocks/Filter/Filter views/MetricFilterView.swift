//
//  MetricFilterView.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import UIKit

enum MetricFilterPeriod: String {
    case yearOverYear = "Year over year growth"
    case quarterOverQuarter = "Quarter over quarter growth"
    case last5Years = "Last 5 years growth per year"
}

enum MetricFilterCompareSign: String {
    case greaterThan = ">"
    case lessThan = "<"
}

protocol MetricFilterViewDelegate: class {
    func didChangeSelection(view: MetricFilterView, filters: (period: MetricFilterPeriod?, compareSign: MetricFilterCompareSign, value: String))
}

class MetricFilterView: FilterView {
    var metricFilter: MetricFilter
    weak var metricViewDelegate: MetricFilterViewDelegate?
    var isExpanded: Bool = false
    override var isSelected: Bool {
        didSet {
            if !isSelected {
                periodPicker.selectedSegmentIndex = UISegmentedControl.noSegment
                comparer.selectedSegmentIndex = UISegmentedControl.noSegment
                percentagePicker.selectedSegmentIndex = UISegmentedControl.noSegment
                valuePicker.selectedSegmentIndex = UISegmentedControl.noSegment
                layer.borderWidth = 0
                isExpanded = false
                explanation.isHidden = true
                period = nil
                compareSign = nil
                value = nil
                animateInOut()
            }
        }
    }
    
    var period: MetricFilterPeriod?
    var compareSign: MetricFilterCompareSign?
    var value: String?
    
    lazy var periodPicker: UISegmentedControl = {
        let seg = UISegmentedControl(items: [MetricFilterPeriod.yearOverYear.rawValue, MetricFilterPeriod.quarterOverQuarter.rawValue, MetricFilterPeriod.last5Years.rawValue])
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
        
        switch metricFilter.associatedValue.filterType {
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
            period = MetricFilterPeriod.init(rawValue: title)
        } else if sender == comparer {
            guard let title = sender.titleForSegment(at: sender.selectedSegmentIndex) else { return }
            compareSign = MetricFilterCompareSign.init(rawValue: title)
        } else if sender == percentagePicker {
            value = sender.titleForSegment(at: sender.selectedSegmentIndex)
        } else if sender == valuePicker {
            value = sender.titleForSegment(at: sender.selectedSegmentIndex)
        }
        
        callDelegateIfNeeded()
    }
    
    func callDelegateIfNeeded() {
        switch metricFilter.associatedValue.filterType {
        case .percentageGrowth:
            if let period = period, let compareSign = compareSign, let value = value {
                explanation.text = period.rawValue + " " + compareSign.rawValue + " " + value
                animateSelected()
                
                metricViewDelegate?.didChangeSelection(view: self, filters: (period: period, compareSign: compareSign, value: value))
            }
        case .metric:
            if let compareSign = compareSign, let value = value {
                explanation.text = compareSign.rawValue + " " + value
                animateSelected()
                
                metricViewDelegate?.didChangeSelection(view: self, filters: (period: nil, compareSign: compareSign, value: value))
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
