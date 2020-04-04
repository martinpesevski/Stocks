//
//  FilterCapViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterCapDelegate: class {
    func didSelectCap(_ filters: [CapFilter])
}

class FilterCapViewController: FilterPageViewController {
    weak var delegate: FilterCapDelegate?
    
    lazy var largeCap = FilterView(filter: CapFilter.largeCap)
    lazy var midCap = FilterView(filter: CapFilter.midCap)
    lazy var smallCap = FilterView(filter: CapFilter.smallCap)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "What is your preferred company size?"
        button.setTitle("Save", for: .normal)
        
        content.addArrangedSubview(largeCap)
        content.addArrangedSubview(midCap)
        content.addArrangedSubview(smallCap)
        content.addArrangedSubview(UIView())
    }
    
    override func onDone() {
        var filters: [CapFilter] = []
        if largeCap.isSelected { filters.append(.largeCap) }
        if midCap.isSelected { filters.append(.midCap) }
        if smallCap.isSelected { filters.append(.smallCap) }

        delegate?.didSelectCap(filters)
        _ = navigationController?.popViewController(animated: true)
    }
}

