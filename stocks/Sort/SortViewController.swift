//
//  SortViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol SortControllerDelegate: class {
    func didSort()
}

class SortViewController: UIViewController, SortViewDelegate {
    @IBOutlet weak var valueDifference: SortView!
    @IBOutlet weak var name: SortView!
    @IBOutlet weak var marketCap: SortView!

    weak var delegate: SortControllerDelegate?
    var viewModel: StocksViewModel!

    override func viewDidLoad() {
        valueDifference.setup(sort: .difference)
        name.setup(sort: .name)
        marketCap.setup(sort: .marketCap)

        valueDifference.delegate = self
        name.delegate = self
        marketCap.delegate = self
    }

    func didSelect(sort: Sort) {
        viewModel.stocks = viewModel.stocks.customSort(sort)
        delegate?.didSort()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
