//
//  SectorFilterView.swift
//  stocks
//
//  Created by Martin Peshevski on 4/4/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol SectorFilterViewDelegate: AnyObject {
    func didChangeSelection(view: SectorFilterView, isSelected: Bool)
}

class SectorFilterView: FilterView {
    var sector: SectorFilter
    weak var sectorDelegate: SectorFilterViewDelegate?
    
    init(filter: SectorFilter, delegate: SectorFilterViewDelegate? = nil) {
        self.sector = filter
        self.sectorDelegate = delegate
        super.init(filter: filter, delegate: nil)
    }
    
    override func onTap() {
        isSelected = !isSelected
        sectorDelegate?.didChangeSelection(view: self, isSelected: isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
