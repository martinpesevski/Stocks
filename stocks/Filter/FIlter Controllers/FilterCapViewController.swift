//
//  FilterCapViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterCapDelegate: class {
    func didChangeSelectionCap(_ filter: CapFilter, isSelected: Bool)
}

class FilterCapViewController: FilterPageViewController, FilterViewDelegate {
    weak var delegate: FilterCapDelegate?
    
    var selectedCap: [CapFilter]? {
        didSet {
            guard let cap = selectedCap else { return }
            
            if cap.contains(.largeCap) { largeCap.isSelected = true }
            if cap.contains(.midCap) { midCap.isSelected = true }
            if cap.contains(.smallCap) { smallCap.isSelected = true }
        }
    }
    
    lazy var largeCap = FilterView(filter: CapFilter.largeCap, delegate: self)
    lazy var midCap = FilterView(filter: CapFilter.midCap, delegate: self)
    lazy var smallCap = FilterView(filter: CapFilter.smallCap, delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "What is your preferred company size?"
        button.setTitle("Save", for: .normal)
        
        content.addArrangedSubview(largeCap)
        content.addArrangedSubview(midCap)
        content.addArrangedSubview(smallCap)
        content.addArrangedSubview(UIView())
    }
    
    func didChangeSelection(view: FilterView, isSelected: Bool) {
        if view == largeCap { delegate?.didChangeSelectionCap(.largeCap, isSelected: isSelected) }
        if view == midCap { delegate?.didChangeSelectionCap(.midCap, isSelected: isSelected) }
        if view == smallCap { delegate?.didChangeSelectionCap(.smallCap, isSelected: isSelected) }
    }
}

