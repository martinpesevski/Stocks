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

protocol SubscriptionManagerDelegate: AnyObject {
    var products: [SKProduct]? { get set }
    func didFinishPurchasing()
    func didFinishRestoring()
}

struct Subscription: Codable {
    var subscribed: String
    var subscriptionType: String?
    var subscriptionEndDate: String?
}

class SubscriptionManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    weak var delegate: SubscriptionManagerDelegate?
    
    var isSubscribed: Bool = false
    var subscriptionType: SubscriptionType?
    var subscriptionEndDate: String?
    
    init(delegate: SubscriptionManagerDelegate? = nil) {
        super.init()
        self.delegate = delegate
        DatabaseManager.shared.userHandle?.child("subscribed").observe(DataEventType.value, with: { snapshot in
            self.isSubscribed = snapshot.value as? Bool ?? false
        })
    }
    
    func loadSubscription(completion: @escaping () -> ()) {
        DatabaseManager.shared.userHandle?.observe(DataEventType.value, with: { snapshot in
            guard let subscription = snapshot.value as? Dictionary<String, Any>,
                let isSubscribed = subscription["subscribed"] as? Bool else {
                    completion()
                    return
            }
            
            self.isSubscribed = isSubscribed
            self.subscriptionType = SubscriptionType.init(title: subscription["subscriptionType"] as? String ?? "")
            self.subscriptionEndDate = subscription["subscriptionEndDate"] as? String
            completion()
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
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("%@", error)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if let error = transaction.error {
                print("transaction failed: \(error.localizedDescription)")
                return
            }
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
