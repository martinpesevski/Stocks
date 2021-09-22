//
//  SortViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol SortControllerDelegate: AnyObject {
    func didSort()
}

class SortViewController: ViewController, SortViewDelegate {
    lazy var valueDifference = SortView(sort: .difference, delegate: self)
    lazy var name = SortView(sort: .name, delegate: self)
    lazy var marketCap = SortView(sort: .marketCap, delegate: self)
    lazy var content = ScrollableStackView(views: [valueDifference, name, marketCap, UIView()], spacing: 10, layoutInsets: UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0))
    
    lazy var button: DoneButton = {
        let btn = DoneButton()
        btn.addTarget(self, action: #selector(onDone), for: .touchUpInside)
        return btn
    }()

    weak var delegate: SortControllerDelegate?
    var viewModel: StocksViewModel

    init(viewModel: StocksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(content)
        view.addSubview(button)
        content.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(button.snp.top)
        }
        button.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(view.layoutMarginsGuide).inset(20)
            make.height.equalTo(70)
        }
    }
    
    func didSelect(sort: Sort) {
        viewModel.filteredStocks = viewModel.filteredStocks.customSort(sort)
        delegate?.didSort()
        dismiss(animated: true, completion: nil)
    }

    @objc func onDone() {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
