//
//  SubscriptionViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import StoreKit

class SubscriptionViewController: StackViewController, SubscriptionManagerDelegate {
    lazy var manager = SubscriptionManager()
    
    var products: [SKProduct]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadCells()
            }
        }
    }
    
    lazy var monthly: SubscriptionCell = {
        let cell = SubscriptionCell(subscriptionType: manager.monthlySubscription)
        cell.button.addTarget(self, action: #selector(onMonthly), for: .touchUpInside)
        return cell
    }()

    lazy var yearly: SubscriptionCell = {
        let cell = SubscriptionCell(subscriptionType: manager.yearlySubscription)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        
        titleView.text = "You need to be subscribed to use this feature"
        subtitleView.text = "Please select a subscription model"
        
        content.addArrangedSubview(monthly)
        content.addArrangedSubview(yearly)
        content.setCustomSpacing(20, after: yearly)
        content.addArrangedSubview(restorePurchases)

        modalPresentationStyle = .overFullScreen
        
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
        manager.getSubscriptionType { type in
            var monthlyLabel = "Subscribed"
            if let first = self.products?[safe: 0], let type = type, type == SubscriptionType.monthly(state: .available) {
                monthlyLabel = "\(first.priceLocale.currencySymbol ?? "")\(first.price)"
            }
            monthly.setup(subscriptionType: manager.monthlySubscription, label: monthlyLabel)

            var yearlyLabel = "Subscribed"
            if let second = products?[safe: 1], manager.yearlySubscription.state == .available {
                yearlyLabel = "\(second.priceLocale.currencySymbol ?? "")\(second.price)"
            }
            yearly.setup(subscriptionType: manager.yearlySubscription, label: yearlyLabel)
        }
    }
}
