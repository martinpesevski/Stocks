//
//  SortView.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol SortViewDelegate: AnyObject {
    func didSelect(sort: Sort)
}

class SortView: AccessoryView {
    var sort: Sort
    weak var delegate: SortViewDelegate?

    override func onTap() {
        delegate?.didSelect(sort: sort)
    }
    
    init(sort: Sort, delegate: SortViewDelegate? = nil) {
        self.sort = sort
        self.delegate = delegate
        super.init()
        
        title.text = sort.rawValue
        explanation.removeFromSuperview()
        snp.makeConstraints { make in make.height.equalTo(100) }
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
        case .marketCap: return self.sorted { $0.ticker.marketCap > $1.ticker.marketCap }
        case .difference: return self.sorted  { (first, second) -> Bool in
            guard let firstIV = first.intrinsicValue?.value, let secondIV = second.intrinsicValue?.value else { return false }
            return firstIV > secondIV
            }
        }
    }
}
