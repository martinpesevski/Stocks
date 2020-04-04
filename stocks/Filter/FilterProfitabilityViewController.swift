//
//  FilterProfitabilityViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterProfitabilityDelegate: class {
    func didSelectProfitability(_ filters: [ProfitabilityFilter])
}

class FilterProfitabilityViewController: FilterPageViewController {
    weak var delegate: FilterProfitabilityDelegate?
    
    lazy var profitable = FilterView(filter: ProfitabilityFilter.profitable)
    lazy var unprofitable = FilterView(filter: ProfitabilityFilter.unprofitable)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "Are you more interested in stable profitable companies, or unprofitable companies with higher growth potential?"
        button.setTitle("Save", for: .normal)

        content.addArrangedSubview(profitable)
        content.addArrangedSubview(unprofitable)
        content.addArrangedSubview(UIView())
    }
    
    override func onDone() {
        var filters: [ProfitabilityFilter] = []
        if profitable.isSelected { filters.append(.profitable) }
        if unprofitable.isSelected { filters.append(.unprofitable) }
        
        delegate?.didSelectProfitability(filters)
        _ = navigationController?.popViewController(animated: true)
    }
}

