//
//  FilterView.swift
//  stocks
//
//  Created by Martin Peshevski on 3/21/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import SnapKit

class AccessoryView: UIView {
    enum AccessoryType {
        case rightArrow
        case downArrow
        case upArrow
        case checkboxFull
        case checkboxEmpty
        case locked

        var image: UIImage? {
            switch self {
            case .rightArrow: return UIImage(named: "right")
            case .downArrow: return UIImage(named: "down")
            case .upArrow: return UIImage(named: "up")
            case .checkboxFull: return UIImage(named: "checkbox")
            case .checkboxEmpty: return UIImage(named: "checkbox-empty")
            case .locked: return UIImage(named: "lock")
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .checkboxFull: return .systemGreen
            default: return .label
            }
        }
    }
    
    lazy var accessoryView: UIImageView = {
        let view = UIImageView(image: accessoryType?.image)
        view.tintColor = .label
        view.snp.makeConstraints { make in make.width.height.equalTo(36) }
        return view
    }()
    
    var accessoryType: AccessoryType? {
        didSet {
            accessoryView.image = accessoryType?.image
            accessoryView.tintColor = accessoryType?.tintColor
        }
    }
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var explanation: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var verticalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, explanation])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return btn
    }()
    
    lazy var content: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [verticalStack])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    lazy var verticalContent: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [content])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.spacing = 15
        return stack
    }()
    
    @objc func onTap() {
        // override in subclasses
    }
    
    init(_ title: String? = nil, accessoryType: AccessoryType? = nil) {
        self.accessoryType = accessoryType
        super.init(frame: .zero)

        if accessoryType != nil { content.addArrangedSubview(accessoryView) }
        self.title.text = title

        layer.cornerRadius = 8
        backgroundColor = .systemGray5
        
        addSubview(verticalContent)
        addSubview(button)
        
        verticalContent.snp.makeConstraints { make in make.edges.equalToSuperview() }
        button.snp.makeConstraints { make in make.edges.equalTo(content) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
