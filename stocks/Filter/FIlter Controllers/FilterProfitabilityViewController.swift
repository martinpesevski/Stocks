//
//  FilterProfitabilityViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterProfitabilityDelegate: AnyObject {
    func didChangeSelectionProfitability(_ filter: ProfitabilityFilter, isSelected: Bool)
}

class FilterProfitabilityViewController: FilterPageViewController, FilterViewDelegate {
    weak var delegate: FilterProfitabilityDelegate?
    
    var selectedProfitability: [ProfitabilityFilter]? {
        didSet {
            guard let prof = selectedProfitability else { return }
            
            if prof.contains(.profitable) { profitable.isSelected = true }
            if prof.contains(.unprofitable) { unprofitable.isSelected = true }
        }
    }
    
    lazy var profitable = FilterView(filter: ProfitabilityFilter.profitable, delegate: self)
    lazy var unprofitable = FilterView(filter: ProfitabilityFilter.unprofitable, delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "Are you more interested in stable profitable companies, or unprofitable companies with higher growth potential?"
        button.setTitle("Save", for: .normal)

        content.addArrangedSubview(profitable)
        content.addArrangedSubview(unprofitable)
        content.addArrangedSubview(UIView())
    }
    
    func didChangeSelection(view: FilterView, isSelected: Bool, isLocked: Bool) {
        if view == profitable { delegate?.didChangeSelectionProfitability(.profitable, isSelected: isSelected) }
        if view == unprofitable { delegate?.didChangeSelectionProfitability(.unprofitable, isSelected: isSelected) }
    }
}

