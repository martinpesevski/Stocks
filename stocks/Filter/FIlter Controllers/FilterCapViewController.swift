//
//  FilterCapViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterCapDelegate: AnyObject {
    func didChangeSelectionCap(_ filter: CapFilter, isSelected: Bool)
}

class FilterCapViewController: FilterPageViewController, FilterViewDelegate, SubscriptionViewControllerDelegate {
    weak var delegate: FilterCapDelegate?
    
    var selectedCap: [CapFilter]? {
        didSet {
            guard let cap = selectedCap else { return }
            
            if cap.contains(.largeCap) { largeCap.isSelected = true }
            if cap.contains(.midCap) { midCap.isSelected = true }
            if cap.contains(.smallCap) { smallCap.isSelected = true }
        }
    }
    
    lazy var largeCap = FilterView(filter: CapFilter.largeCap, delegate: self)
    lazy var midCap = FilterView(filter: CapFilter.midCap, delegate: self, isLocked: !subscriptionManager.isSubscribed)
    lazy var smallCap = FilterView(filter: CapFilter.smallCap, delegate: self, isLocked: !subscriptionManager.isSubscribed)
    
    var selectedSubscribing: FilterView? = nil
    
    var subscriptionManager: SubscriptionManager
    
    init(manager: SubscriptionManager) {
        self.subscriptionManager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    func didDismiss() {
        midCap.setup(isLocked: !subscriptionManager.isSubscribed, isSelected: midCap.isSelected ? true : selectedSubscribing == midCap)
        smallCap.setup(isLocked: !subscriptionManager.isSubscribed, isSelected: smallCap.isSelected ? true : selectedSubscribing == smallCap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.text = "What is your preferred company size?"
        button.setTitle("Save", for: .normal)
        
        content.addArrangedSubview(largeCap)
        content.addArrangedSubview(midCap)
        content.addArrangedSubview(smallCap)
        content.addArrangedSubview(UIView())
    }
    
    func didChangeSelection(view: FilterView, isSelected: Bool, isLocked: Bool) {
        if view == largeCap { delegate?.didChangeSelectionCap(.largeCap, isSelected: isSelected) }
        if view == midCap {
            if isLocked {
                selectedSubscribing = midCap
                let sub = SubscriptionViewController(manager: subscriptionManager)
                sub.delegate = self
                present(sub, animated: true, completion: nil)
                return
            }
            delegate?.didChangeSelectionCap(.midCap, isSelected: isSelected)
        }
        if view == smallCap {
            if isLocked {
                selectedSubscribing = smallCap
                let sub = SubscriptionViewController(manager: subscriptionManager)
                sub.delegate = self
                present(sub, animated: true, completion: nil)
                return
            }
            delegate?.didChangeSelectionCap(.smallCap, isSelected: isSelected)
        }
    }
}

