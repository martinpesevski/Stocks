//
//  SubscriptionManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation
import StoreKit

protocol SubscriptionManagerDelegate: class {
    var products: [SKProduct]? { get set }
}

class SubscriptionManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    weak var delegate: SubscriptionManagerDelegate?
    
    init(delegate: SubscriptionManagerDelegate? = nil) {
        super.init()
        self.delegate = delegate
    }
    
    var monthlySubscription: SubscriptionType {
        return UserDefaults.standard.bool(forKey: "monthlySub") ? .monthly(state: .subscribed) : .monthly(state: .available)
    }
    
    var yearlySubscription: SubscriptionType {
        return UserDefaults.standard.bool(forKey: "yearlySub") ? .yearly(state: .subscribed) : .yearly(state: .available)
    }
    
    func loadProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(arrayLiteral: "com.mpeshevski.stocker.monthly", "com.mpeshevski.stocker.yearly"))
        request.delegate = self
        request.start()
    }
    
    func purchase(_ product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        payment.applicationUsername = "Stocker Pro"
        let queue = SKPaymentQueue.default()
        queue.add(self)
        queue.add(payment)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        delegate?.products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState, transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing, .deferred: break // do nothing
            case .purchased:
                queue.finishTransaction(transaction)
            case .restored:
                queue.finishTransaction(transaction)
            case .failed:
                queue.finishTransaction(transaction)
            @unknown default:
                break
            }
        }
    }
}
