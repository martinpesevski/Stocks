//
//  SelectedFilterView.swift
//  Stocker
//
//  Created by Martin Peshevski on 23.5.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import UIKit

protocol SelectedFilterViewDelegate: AnyObject {
    func onClearSelected(filter: MetricFilter)
}

class SelectedFilterView: UIView {
    var delegate: SelectedFilterViewDelegate?
    var filter: MetricFilter
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(text: nil, font: UIFont.systemFont(ofSize: 14), alignment: .left, color: .label)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var clearButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "close"), for: .normal)
        b.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        b.snp.makeConstraints { make in make.width.height.equalTo(20) }
        b.tintColor = .label
        return b
    }()

    lazy var content: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, clearButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    init(filter: MetricFilter, text: String, delegate: SelectedFilterViewDelegate) {
        self.filter = filter
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        titleLabel.text = text
        layer.backgroundColor = UIColor.systemGreen.cgColor
        layer.cornerRadius = 15
        
        addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    @objc func onClose() {
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) { [unowned self] in
                self.isHidden = true
            } completion: { _ in
                self.removeFromSuperview()
            }
        })
        delegate?.onClearSelected(filter: filter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
