//
//  SortView.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol SortViewDelegate: class {
    func didSelect(sort: Sort)
}

class SortView: UIView {
    var sort: Sort?
    weak var delegate: SortViewDelegate?

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
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return btn
    }()

    func setup(sort: Sort) {
        self.sort = sort
        title.text = sort.rawValue
    }

    @objc func onTap() {
        guard let sort = sort else { return }
        delegate?.didSelect(sort: sort)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layer.cornerRadius = 8

        addSubview(title)
        addSubview(button)

        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }

        button.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
}

enum Sort: String {
    case difference = "Value difference"
    case name = "Name"
    case marketCap = "Market cap"
}

extension Sequence where Iterator.Element == Stock
{
    func customSort(_ sort: Sort) -> [Stock] {
        switch sort {
        case .name: return self.sorted { $0.ticker.symbol < $1.ticker.symbol }
        case .marketCap: return self.sorted { (first, second) -> Bool in
            guard let firstMC = first.quote?.profile.mktCap?.floatValue,
                let secondMC = second.quote?.profile.mktCap?.floatValue else { return false }
            return firstMC > secondMC
        }
        case .difference: return self.sorted  { (first, second) -> Bool in
            guard let firstIV = first.intrinsicValue?.value, let secondIV = second.intrinsicValue?.value else { return false }
            return firstIV > secondIV
            }
        }
    }
}
