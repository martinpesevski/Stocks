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
    func didFinishPurchasing()
    func didFinishRestoring()
}

class SubscriptionManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    weak var delegate: SubscriptionManagerDelegate?
    
    init(delegate: SubscriptionManagerDelegate? = nil) {
        super.init()
        self.delegate = delegate
    }
    
    var monthlySubscription: SubscriptionType {
        return UserDefaults.standard.bool(forKey: SubscriptionType.monthly(state: .subscribed).productIdentifier) ? .monthly(state: .subscribed) : .monthly(state: .available)
    }
    
    var yearlySubscription: SubscriptionType {
        return UserDefaults.standard.bool(forKey: SubscriptionType.yearly(state: .subscribed).productIdentifier) ? .yearly(state: .subscribed) : .yearly(state: .available)
    }
    
    func loadProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(arrayLiteral: monthlySubscription.productIdentifier, yearlySubscription.productIdentifier))
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
    
    func restore() {
        if (SKPaymentQueue.canMakePayments()) {
            let queue = SKPaymentQueue.default()
            queue.add(self)
            queue.restoreCompletedTransactions()
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        delegate?.products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState, transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing, .deferred: break //do nothing
            case .purchased:
                queue.finishTransaction(transaction)
                save(transaction.payment.productIdentifier, state: .subscribed)
                delegate?.didFinishPurchasing()
            case .restored:
                queue.finishTransaction(transaction)
                save(transaction.payment.productIdentifier, state: .subscribed)
            case .failed:
                queue.finishTransaction(transaction)
                save(transaction.payment.productIdentifier, state: .available)
            @unknown default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        delegate?.didFinishRestoring()
    }
    
    func save(_ id: String, state: SubscriptionState) {
        let subType = id == yearlySubscription.productIdentifier ? SubscriptionType.yearly(state: state) : SubscriptionType.monthly(state: state)
        
        UserDefaults.standard.set(subType.state == .subscribed, forKey: subType.productIdentifier)
        switch subType {
        case .monthly:  UserDefaults.standard.set(false, forKey: yearlySubscription.productIdentifier)
        case .yearly:  UserDefaults.standard.set(false, forKey: monthlySubscription.productIdentifier)
        }
        UserDefaults.standard.synchronize()
    }
}
