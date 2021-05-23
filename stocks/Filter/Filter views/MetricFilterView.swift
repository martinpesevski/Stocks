//
//  MetricFilterView.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import UIKit

protocol MetricFilterViewDelegate: class {
    func didChangeSelection(view: MetricFilterView, isSelected: Bool)
}

class MetricFilterView: FilterView {
    var metricFilter: MetricFilter
    weak var metricViewDelegate: MetricFilterViewDelegate?
    var isExpanded: Bool = false
    
    lazy var periodPicker: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Year over year", "Quarter over quarter", "Last 5 years"])
        seg.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return seg
    }()
    lazy var comparer: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["<", ">"])
        seg.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        return seg
    }()
    lazy var percentagePicker: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["0","5%", "10%", "15%", "20%", "25%", "30%"])
        seg.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        return seg
    }()

    lazy var filterOptionsView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [periodPicker, comparer, percentagePicker])
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
    }
    
    override func onTap() {
        accessoryType = isExpanded ? .upArrow : .downArrow
        isExpanded = !isExpanded
        self.filterOptionsView.isHidden = !self.isExpanded
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
