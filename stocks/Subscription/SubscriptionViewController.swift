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
            guard let products = products else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let first = products[safe: 0] { self.monthly.label.text = "\(first.priceLocale.currencySymbol ?? "")\(first.price)"}
                if let second = products[safe: 1] { self.yearly.label.text = "\(second.priceLocale.currencySymbol ?? "")\(second.price)"}
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        
        titleView.text = "You need to be subscribed to use this feature"
        subtitleView.text = "Please select a subscription model"
        
        content.addArrangedSubview(monthly)
        content.addArrangedSubview(yearly)
        
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
}
