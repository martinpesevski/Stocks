//
//  FilterViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/21/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func didFinishFiltering(stocks: [Stock], filteredStocks: [Stock])
}

class FilterViewController: UIViewController {
    
    @IBOutlet var largeCap: FilterView!
    @IBOutlet var midCap: FilterView!
    @IBOutlet var smallCap: FilterView!
    @IBOutlet var profitable: FilterView!
    @IBOutlet var unprofitable: FilterView!

    weak var delegate: FilterDelegate?

    lazy var filterViews: [FilterView] = [largeCap, midCap, smallCap, profitable, unprofitable]
    var filters: [Filter] = []
    var stocks: [Stock] = []
    var filteredStocks: [Stock] = []
    var isModal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        largeCap.setup(filter: .largeCap)
        midCap.setup(filter: .midCap)
        smallCap.setup(filter: .smallCap)
        profitable.setup(filter: .profitable)
        unprofitable.setup(filter: .unprofitable)
    }
    
    @IBAction func onDone(_ sender: Any) {
        for view in filterViews where view.isSelected {
            if let filter = view.filter { filters.append(filter) }
        }
        
        filteredStocks = stocks.filter { $0.isValid(filters: filters) }
        filteredStocks.sort { $0.discount! > $1.discount! }

        if isModal {
            delegate?.didFinishFiltering(stocks: stocks, filteredStocks: filteredStocks)
            dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "list", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ListViewController else { return }
        destination.stocks = stocks
        destination.filteredStocks = filteredStocks
    }
}
