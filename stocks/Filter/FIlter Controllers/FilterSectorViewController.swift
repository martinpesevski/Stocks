//
//  FilterSectorViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterSectorDelegate: AnyObject {
    func didChangeSelectionSector(_ filter: SectorFilter, isSelected: Bool)
}

class FilterSectorViewController: FilterPageViewController, SectorFilterViewDelegate {
    weak var delegate: FilterSectorDelegate?
    var selectedSectors: [SectorFilter]? {
        didSet {
            guard let sectors = selectedSectors else { return }
            
            for sector in sectorViews {
                if sectors.contains(sector.sector) { sector.isSelected = true }
            }
        }
    }
    
    lazy var energy = SectorFilterView(filter: SectorFilter.energy, delegate: self)
    lazy var basicMaterials = SectorFilterView(filter: SectorFilter.basicMaterials, delegate: self)
    lazy var industrials = SectorFilterView(filter: SectorFilter.industrials, delegate: self)
    lazy var consumerCyclical = SectorFilterView(filter: SectorFilter.consumerCyclical, delegate: self)
    lazy var consumerDefensive = SectorFilterView(filter: SectorFilter.consumerDefensive, delegate: self)
    lazy var healthcare = SectorFilterView(filter: SectorFilter.healthcare, delegate: self)
    lazy var financial = SectorFilterView(filter: SectorFilter.financial, delegate: self)
    lazy var tech = SectorFilterView(filter: SectorFilter.tech, delegate: self)
    lazy var communications = SectorFilterView(filter: SectorFilter.communicationServices, delegate: self)
    lazy var utilities = SectorFilterView(filter: SectorFilter.utilities, delegate: self)
    lazy var realEstate = SectorFilterView(filter: SectorFilter.realEstate, delegate: self)
    
    var sectorViews: [SectorFilterView] {
        [energy, basicMaterials, industrials, consumerCyclical, consumerDefensive, healthcare,
         financial, tech, communications, utilities, realEstate]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "Which industrial sector would you prefer to research?"
        button.setTitle("Save", for: .normal)

        for view in sectorViews {
            content.addArrangedSubview(view)
        }

        content.addArrangedSubview(UIView())
    }
    
    func didChangeSelection(view: SectorFilterView, isSelected: Bool) {
        delegate?.didChangeSelectionSector(view.sector, isSelected: isSelected)
    }
}

