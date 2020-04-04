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
    }
}

class NavigationController: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.tintColor = .label
    }
}

class ScrollableStackView: UIStackView {
    var stockStack: UIStackView

    lazy var scrollview: UIScrollView = {
        let scroll = UIScrollView()
        scroll.addSubview(stockStack)
        scroll.alwaysBounceVertical = true
        stockStack.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        return scroll
    }()
    
    init(views: [UIView], distribution: Distribution? = nil, alignment: Alignment? = nil, spacing: CGFloat = 0, layoutInsets: UIEdgeInsets? = nil) {
        stockStack = UIStackView.init(views: views, axis: .vertical, distribution: distribution, alignment: alignment, spacing: spacing, layoutInsets: layoutInsets)

        super.init(frame: .zero)
        
        axis = .vertical
        addSubview(scrollview)
        scrollview.snp.makeConstraints { make in make.edges.equalToSuperview() }
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
