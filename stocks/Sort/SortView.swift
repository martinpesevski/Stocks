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

class SortView: AccessoryView {
    var sort: Sort
    weak var delegate: SortViewDelegate?

    func setup(sort: Sort) {
        title.text = sort.rawValue
    }

    override func onTap() {
        delegate?.didSelect(sort: sort)
    }
    
    init(sort: Sort) {
        self.sort = sort
        super.init()
        
        title.text = sort.rawValue
        explanation.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
