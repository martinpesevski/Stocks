//
//  FilterView.swift
//  stocks
//
//  Created by Martin Peshevski on 3/21/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import SnapKit

class FilterView: UIView {
    var isSelected = false {
        didSet {
            selectionBox.image = UIImage(named: isSelected ? "checkbox" : "checkbox-empty")
            selectionBox.tintColor = isSelected ? .systemGreen : .white
        }
    }
    
    var filter: Filter?
    
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
    
    lazy var selectionBox: UIImageView = {
        let view = UIImageView(image: UIImage.init(named: "checkbox-empty"))
        view.tintColor = .white
        view.snp.makeConstraints { make in make.width.height.equalTo(36) }
        return view
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
        let stack = UIStackView(arrangedSubviews: [verticalStack, selectionBox])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    func setup(filter: Filter) {
        self.filter = filter
        title.text = filter.title
        explanation.text = filter.explanation
        isSelected = UserDefaults.standard.bool(forKey: filter.title)
    }
    
    @objc func onTap() {
        isSelected = !isSelected
        if let text = filter?.title {
            UserDefaults.standard.set(isSelected, forKey: text)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = 8
        
        addSubview(content)
        addSubview(button)
        
        content.snp.makeConstraints { make in make.edges.equalToSuperview() }
        button.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
}
