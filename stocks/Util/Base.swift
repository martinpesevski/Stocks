//
//  Base.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
    }
}

class NavigationController: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.tintColor = .label
    }
}

class StyledTextField: UITextField {
    init() {
        super.init(frame: .zero)
        let border = UIView()
        border.backgroundColor = .systemGreen
        addSubview(border)
        border.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        snp.makeConstraints { make in make.height.equalTo(50) }
        tintColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KeyValueView: UIStackView {
    lazy var keyLabel = UILabel(font: UIFont.systemFont(ofSize: 15))
    lazy var valueLabel = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .right)
    lazy var button = UIButton()
    lazy var background: UIView = {
        let bg = UIView()
        bg.layer.cornerRadius = 5
        bg.layer.masksToBounds = true
        bg.backgroundColor = .systemGray6
        bg.addSeparator()
        
        return bg
    }()
    
    init(key: String, value: String) {
        super.init(frame: .zero)
        
        addSubview(background)
        background.snp.makeConstraints { make in make.edges.equalToSuperview() }
        
        addArrangedSubview(keyLabel)
        addArrangedSubview(valueLabel)
        addSubview(button)
        button.snp.makeConstraints { make in make.edges.equalToSuperview() }


        axis = .horizontal
        layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        isLayoutMarginsRelativeArrangement = true
        
        setup(key: key, value: value)
    }
    
    func setup(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScrollableStackView: UIStackView {
    var stockStack: UIStackView

    lazy var scrollview: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(stockStack)
        scroll.alwaysBounceVertical = true
        stockStack.snp.makeConstraints { make in
            make.edges.equalTo(scroll.contentLayoutGuide)
            make.width.equalToSuperview()
        }
        return scroll
    }()
    
    init(views: [UIView], distribution: Distribution? = nil, alignment: Alignment? = nil, spacing: CGFloat = 0, layoutInsets: UIEdgeInsets? = nil) {
        stockStack = UIStackView.init(views: views, axis: .vertical, distribution: distribution, alignment: alignment, spacing: spacing, layoutInsets: layoutInsets)

        super.init(frame: .zero)
        
        axis = .vertical
        addSubview(scrollview)
        scrollview.snp.makeConstraints { make in make.edges.equalTo(layoutMarginsGuide) }
    }
    
    override func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        stockStack.setCustomSpacing(spacing, after: arrangedSubview)
    }
    
    override func addArrangedSubview(_ view: UIView) {
        stockStack.addArrangedSubview(view)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
