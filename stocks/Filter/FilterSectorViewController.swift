//
//  FilterSectorViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterSectorDelegate: class {
    func didSelectSector(_ filters: [SectorFilter])
}

class FilterSectorViewController: FilterPageViewController {
    weak var delegate: FilterSectorDelegate?
    
    lazy var energy = FilterView(filter: SectorFilter.energy)
    lazy var basicMaterials = FilterView(filter: SectorFilter.basicMaterials)
    lazy var industrials = FilterView(filter: SectorFilter.industrials)
    lazy var consumerCyclical = FilterView(filter: SectorFilter.consumerCyclical)
    lazy var consumerDefensive = FilterView(filter: SectorFilter.consumerDefensive)
    lazy var healthcare = FilterView(filter: SectorFilter.healthcare)
    lazy var financial = FilterView(filter: SectorFilter.financial)
    lazy var tech = FilterView(filter: SectorFilter.tech)
    lazy var communications = FilterView(filter: SectorFilter.communicationServices)
    lazy var utilities = FilterView(filter: SectorFilter.utilities)
    lazy var realEstate = FilterView(filter: SectorFilter.realEstate)
    
    var sectorViews: [FilterView] {
        [energy, basicMaterials, industrials, consumerCyclical, consumerDefensive, healthcare,
         financial, tech, communications, utilities, realEstate]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "Which industrial sector would you prefer to research?"
        button.setTitle("Save", for: .normal)

        content.addArrangedSubview(energy)
        content.addArrangedSubview(basicMaterials)
        content.addArrangedSubview(industrials)
        content.addArrangedSubview(consumerCyclical)
        content.addArrangedSubview(consumerDefensive)
        content.addArrangedSubview(healthcare)
        content.addArrangedSubview(financial)
        content.addArrangedSubview(tech)
        content.addArrangedSubview(communications)
        content.addArrangedSubview(utilities)
        content.addArrangedSubview(realEstate)

        content.addArrangedSubview(UIView())
    }
    
    override func onDone() {
        var filters: [SectorFilter] = []
        if energy.isSelected { filters.append(.energy) }
        if basicMaterials.isSelected { filters.append(.basicMaterials) }
        if industrials.isSelected { filters.append(.industrials) }
        if consumerCyclical.isSelected { filters.append(.consumerCyclical) }
        if consumerDefensive.isSelected { filters.append(.consumerDefensive) }
        if healthcare.isSelected { filters.append(.healthcare) }
        if financial.isSelected { filters.append(.financial) }
        if tech.isSelected { filters.append(.tech) }
        if communications.isSelected { filters.append(.communicationServices) }
        if utilities.isSelected { filters.append(.utilities) }
        if realEstate.isSelected { filters.append(.realEstate) }
        

        delegate?.didSelectSector(filters)
        _ = navigationController?.popViewController(animated: true)
    }
}

