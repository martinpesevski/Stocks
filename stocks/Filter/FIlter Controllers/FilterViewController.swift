//
//  FilterViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/21/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import StoreKit

protocol FilterDelegate: AnyObject {
    func didFinishFiltering()
}

class FilterViewController: FilterPageViewController {
    lazy var marketCapController = FilterCapViewController(manager: subscriptionManager)
    lazy var sectorController = FilterSectorViewController()
    lazy var profitabilityController = FilterProfitabilityViewController()
    lazy var metricController = FilterMetricViewController()

    lazy var marketCap = DrillDownView(filter: .marketCap(filters: filter.capFilters), delegate: self)
    lazy var sector = DrillDownView(filter: .sector(filters: filter.sectorFilters), delegate: self)
    lazy var profitability = DrillDownView(filter: .profitability(filters: filter.profitabilityFilters), delegate: self)
    lazy var metrics = DrillDownView(filter: .metric(filters: filter.metricFilters), delegate: self)
    
    weak var delegate: FilterDelegate?

    lazy var filter: Filter = {
        if let ftrData = UserDefaults.standard.object(forKey: "filter") as? Data,
            let ftr = try? JSONDecoder().decode(Filter.self, from: ftrData) {
            return ftr
        } else {
            var ftr = Filter()
            ftr.capFilters = [.largeCap]
            ftr.sectorFilters = [.tech]
            ftr.profitabilityFilters = [.profitable]
            ftr.metricFilters = [MetricFilter(associatedValueMetric: AnyMetricType(FinancialRatioMetricType.priceEarningsRatio),
                                              period: .lastQuarter, compareSign: .lessThan, value: "10")]
            return ftr
        }
    }()
    
    var viewModel: StocksViewModel!
    var subscriptionManager: SubscriptionManager
    var isModal = false
    
    init(viewModel: StocksViewModel = StocksViewModel()) {
        self.viewModel = viewModel
        self.subscriptionManager = SubscriptionManager()
        super.init(nibName: nil, bundle: nil)

        marketCapController.delegate = self
        sectorController.delegate = self
        profitabilityController.delegate = self
        metricController.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "We would like to know what kind of companies you're intrested in."
        
        content.addArrangedSubview(marketCap)
        content.addArrangedSubview(sector)
        content.addArrangedSubview(profitability)
        content.addArrangedSubview(metrics)
        content.addArrangedSubview(UIView())
        
        view.startLoading()
        subscriptionManager.loadSubscription {
            self.view.finishLoading()
        }
    }
    
    override func onDone() {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(filter) {
            UserDefaults.standard.set(encoded, forKey: "filter")
        }
        
        self.viewModel.filter = filter
        button.startLoading()
        
        if viewModel.didLoadOnce {
            viewModel.filter(filter: filter)
            showList()
        } else {
            loadViewModel()
        }
    }
    
    func loadViewModel() {
        viewModel.load { [weak self] in
            guard let self = self else { return }
            self.button.finishLoading()
            self.viewModel.filter(filter: self.filter)
            DispatchQueue.main.async {
                self.showList()
            }
        }
    }
    
    func showList() {
        if isModal {
            delegate?.didFinishFiltering()
            dismiss(animated: true, completion: nil)
        } else {
            let listVC = ListViewController(viewModel: viewModel)
            show(listVC, sender: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterViewController: FilterCapDelegate, DrillDownDelegate, FilterProfitabilityDelegate, FilterSectorDelegate, FilterMetricDelegate {
    func didChangeSelectionCap(_ filter: CapFilter, isSelected: Bool) {
        if isSelected {
            self.filter.capFilters.append(filter)
        } else if let index = self.filter.capFilters.firstIndex(of: filter) {
            self.filter.capFilters.remove(at: index)
        }
        marketCap.filter = .marketCap(filters: self.filter.capFilters)
    }
    
    func didChangeSelectionSector(_ filter: SectorFilter, isSelected: Bool) {
        if isSelected {
            self.filter.sectorFilters.append(filter)
        } else if let index = self.filter.sectorFilters.firstIndex(of: filter) {
            self.filter.sectorFilters.remove(at: index)
        }
        sector.filter = .sector(filters: self.filter.sectorFilters)
    }
    
    func didChangeSelectionProfitability(_ filter: ProfitabilityFilter, isSelected: Bool) {
        if isSelected {
            self.filter.profitabilityFilters.append(filter)
        } else if let index = self.filter.profitabilityFilters.firstIndex(of: filter) {
            self.filter.profitabilityFilters.remove(at: index)
        }
        profitability.filter = .profitability(filters: self.filter.profitabilityFilters)
    }
    
    func didChangeSelection(selectedFilters: [MetricFilter]) {
        self.filter.metricFilters = selectedFilters
        metrics.filter = .metric(filters: selectedFilters)
    }
    
    func didSelect(filter: FilterType) {
        switch filter {
        case .marketCap:
            marketCapController.selectedCap = self.filter.capFilters
            show(marketCapController, sender: self)
        case .profitability:
            profitabilityController.selectedProfitability = self.filter.profitabilityFilters
            show(profitabilityController, sender: self)
        case .sector:
            sectorController.selectedSectors = self.filter.sectorFilters
            show(sectorController, sender: self)
        case .metric:
            metricController.selectedFilters = self.filter.metricFilters
            show(metricController, sender: self)
        }
    }
}

extension FilterViewController: SKProductsRequestDelegate, SKPaymentQueueDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response)
        let product = response.products[0]
        let payment = SKMutablePayment(product: product)
        payment.applicationUsername = "Stocker Pro"
        let queue = SKPaymentQueue.default()
        queue.delegate = self
        queue.add(payment)
    }
    
    func paymentQueue(_ paymentQueue: SKPaymentQueue, shouldContinue transaction: SKPaymentTransaction, in newStorefront: SKStorefront) -> Bool {
        if transaction.transactionState == SKPaymentTransactionState.purchased { print("HOORAY") } else { print("BOOO") }
        return true
    }
}
