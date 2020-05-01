//
//  SubscriptionCell.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

enum SubscriptionState {
    case subscribed
    case available
}

enum SubscriptionType: Equatable {
    case monthly(state: SubscriptionState)
    case yearly(state: SubscriptionState)
    
    var title: String {
        switch self {
        case .monthly: return "Monthly subscription"
        case .yearly: return "Yearly subscription"
        }
    }
    
    var image: UIImage {
        switch self {
        case .monthly: return UIImage(named: "coin")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        case .yearly: return UIImage(named: "coins")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .monthly(let state): return state == .subscribed ? UIColor.systemGray2 : UIColor.systemGray5
        case .yearly(let state): return state == .subscribed ? UIColor.systemGray2 : UIColor.systemGray5
        }
    }
    
    var state: SubscriptionState {
        switch self {
        case .monthly(let state): return state
        case .yearly(let state): return state
        }
    }
    
    var hidesDiscountLabel: Bool {
        switch self {
        case .monthly: return true
        case .yearly(let state): return state == .subscribed
        }
    }
    
    var productIdentifier: String {
        switch self {
        case .monthly: return "com.mpeshevski.stocker.monthly"
        case .yearly: return "com.mpeshevski.stocker.yearly"
        }
    }
}

class SubscriptionCell: AccessoryView {
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.contentMode = .scaleAspectFit
        image.tintColor = .label
        return image
    }()
    
    lazy var label = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .center)
    lazy var discountLabel = UILabel(text: "30% cheaper!",font: UIFont.systemFont(ofSize: 12), alignment: .center, color: .systemGreen)
    lazy var labelStack = UIStackView(views: [label, discountLabel], axis: .vertical, spacing: 5)

    init(subscriptionType: SubscriptionType) {
        super.init(subscriptionType.title, accessoryType: nil)
        
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        imageView.image = subscriptionType.image
        
        explanation.isHidden = true
        content.insertArrangedSubview(imageView, at: 0)
        content.addArrangedSubview(labelStack)
            
        setup(subscriptionType: subscriptionType)
        
        snp.makeConstraints { make in make.height.equalTo(70) }
    }
    
    func setup(subscriptionType: SubscriptionType, label: String = "") {
        discountLabel.isHidden = subscriptionType.hidesDiscountLabel
        backgroundColor = subscriptionType.backgroundColor
        self.label.text = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
