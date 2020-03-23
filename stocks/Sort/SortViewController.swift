//
//  SortViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol SortControllerDelegate: class {
    func didSort(stocks: [Stock])
}

class SortViewController: UIViewController, SortViewDelegate {
    @IBOutlet weak var valueDifference: SortView!
    @IBOutlet weak var name: SortView!
    @IBOutlet weak var marketCap: SortView!

    weak var delegate: SortControllerDelegate?
    var stocks: [Stock] = []

    override func viewDidLoad() {
        valueDifference.setup(sort: .difference)
        name.setup(sort: .name)
        marketCap.setup(sort: .marketCap)

        valueDifference.delegate = self
        name.delegate = self
        marketCap.delegate = self
    }

    func didSelect(sort: Sort) {
        stocks = stocks.customSort(sort)
        delegate?.didSort(stocks: stocks)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
