//
//  FilterViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/21/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func didFinishFiltering()
}

class FilterViewController: FilterPageViewController {
    lazy var marketCapController = FilterCapViewController()
    lazy var sectorController = FilterSectorViewController()
    lazy var profitabilityController = FilterProfitabilityViewController()

    lazy var marketCap = DrillDownView(filter: .marketCap(filters: [.largeCap]))
    lazy var sector = DrillDownView(filter: .sector(filters: [.tech]))
    lazy var profitability = DrillDownView(filter: .profitability(filters: [.profitable]))
    
    weak var delegate: FilterDelegate?

    lazy var filterViews: [DrillDownView] = [marketCap, sector, profitability]
    var filter: Filter = Filter()
    var viewModel: StocksViewModel!
    var isModal = false
    
    init(viewModel: StocksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        marketCap.delegate = self
        sector.delegate = self
        profitability.delegate = self
        
        marketCapController.delegate = self
        sectorController.delegate = self
        profitabilityController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "We would like to know what kind of companies you're intrested in."
        
        content.addArrangedSubview(marketCap)
        content.addArrangedSubview(sector)
        content.addArrangedSubview(profitability)
        content.addArrangedSubview(UIView())
    }
    
    override func onDone() {
        if isModal {
            delegate?.didFinishFiltering()
            dismiss(animated: true, completion: nil)
        } else {
            viewModel.load { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
//                    self.viewModel.filter(filter: self.filter)
                    let listVC = ListViewController(viewModel: self.viewModel)
                    self.show(listVC, sender: self)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterViewController: FilterCapDelegate, DrillDownDelegate, FilterProfitabilityDelegate, FilterSectorDelegate {
    func didSelectCap(_ filters: [CapFilter]) {
        filter.capFilters = filters
        marketCap.filter = .marketCap(filters: filters)
    }
    
    func didSelectSector(_ filters: [SectorFilter]) {
        filter.sectorFilters = filters
        sector.filter = .sector(filters: filters)
    }
    
    func didSelectProfitability(_ filters: [ProfitabilityFilter]) {
        filter.profitabilityFilters = filters
        profitability.filter = .profitability(filters: filters)
    }
    
    func didSelect(filter: FilterType) {
        switch filter {
        case .marketCap: show(marketCapController, sender: self)
        case .profitability: show(profitabilityController, sender: self)
        case .sector: show(sectorController, sender: self)
        }
    }
}
