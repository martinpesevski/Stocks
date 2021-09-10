//
//  SubscriptionViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import StoreKit
 
protocol SubscriptionViewControllerDelegate: AnyObject {
    func didDismiss()
}

class SubscriptionViewController: StackViewController, SubscriptionManagerDelegate {
    var manager: SubscriptionManager
    weak var delegate: SubscriptionViewControllerDelegate?
    
    var products: [SKProduct]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.view.finishLoading()
                self?.reloadCells()
            }
        }
    }
    
    lazy var monthly: SubscriptionCell = {
        let cell = SubscriptionCell()
        cell.button.addTarget(self, action: #selector(onMonthly), for: .touchUpInside)
        return cell
    }()

    lazy var yearly: SubscriptionCell = {
        let cell = SubscriptionCell()
        cell.button.addTarget(self, action: #selector(onYearly), for: .touchUpInside)
        return cell
    }()
    
    lazy var restorePurchases: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onRestore), for: .touchUpInside)
        btn.setTitle("Restore purchases", for: .normal)
        btn.setTitleColor(.systemGreen, for: .normal)
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    
    init(manager: SubscriptionManager) {
        self.manager = manager
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        presentationController?.delegate = self
        
        titleView.text = "You need to be subscribed to use this feature"
        subtitleView.text = "Please select a subscription model"
        
        content.addArrangedSubview(monthly)
        content.addArrangedSubview(yearly)
        content.setCustomSpacing(20, after: yearly)
        content.addArrangedSubview(restorePurchases)

        modalPresentationStyle = .overFullScreen
        
        view.startLoading()
        manager.loadProducts()
    }
    
    @objc func onMonthly() {
        guard let product = products?[safe: 0] else { return }
        manager.purchase(product)
    }
    
    @objc func onYearly() {
        guard let product = products?[safe: 1] else { return }
        manager.purchase(product)
    }
    
    @objc func onRestore() {
        manager.restore()
    }
    
    func didFinishPurchasing() {
        reloadCells()
    }
    
    func didFinishRestoring() {
        let alert = UIAlertController(title: "Success!", message: "You have successfully restored your purchases.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        Router.topViewController()?.present(alert, animated: true, completion: nil)
        reloadCells()
    }
    
    func reloadCells() {
        guard let type = manager.subscriptionType else {
            self.setup(monthly: .available, yearly: .available)
            return
        }
        
        switch type {
        case .monthly(state: let state): self.setup(monthly: state, yearly: .available)
        case .yearly(state: let state): self.setup(monthly: .available, yearly: state)
        }
    }
    
    func setup(monthly: SubscriptionState, yearly: SubscriptionState) {
        var yearlyLabel: String?
        if let second = self.products?[safe: 1], yearly == .available {
            yearlyLabel = second.currencyPrice
        }
        var monthlyLabel: String?
        if let first = products?[safe: 0], monthly == .available {
            monthlyLabel = first.currencyPrice
        }
        self.yearly.setup(subscriptionType: .yearly(state: yearly), label: yearlyLabel)
        self.monthly.setup(subscriptionType: .monthly(state: monthly), label: monthlyLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SubscriptionViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.didDismiss()
    }
}
