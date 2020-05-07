//
//  SubscriptionManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation
import StoreKit
import FirebaseDatabase

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

    func getSubscriptionType(completion: @escaping (SubscriptionType?) -> ()) {
        DatabaseManager.shared.userHandle?.child("subscriptionType").observe(DataEventType.value, with: { snapshot in
            guard let subType = snapshot.value as? String else {
                completion(nil)
                return
            }

            switch subType {
            case "Monthly subscription": completion(.monthly(state: .subscribed))
            case "Yearly subscription": completion(.yearly(state: .subscribed))
            default: completion(nil)
            }
        })
    }
    
    func loadProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(arrayLiteral: SubscriptionType.monthly(state: .available).productIdentifier, SubscriptionType.yearly(state: .available).productIdentifier))
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
        let subType = id == SubscriptionType.yearly(state: state).productIdentifier ? SubscriptionType.yearly(state: state) : SubscriptionType.monthly(state: state)
        DatabaseManager.shared.userHandle?.setValue(["subscribed": subType.state == .subscribed,
                                                     "subscriptionType": subType.title])
    }
}
