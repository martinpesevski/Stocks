//
//  FilterViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 3/21/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet var largeCap: FilterView!
    @IBOutlet var midCap: FilterView!
    @IBOutlet var smallCap: FilterView!
    @IBOutlet var profitable: FilterView!
    @IBOutlet var unprofitable: FilterView!
    
    lazy var filterViews: [FilterView] = [largeCap, midCap, smallCap, profitable, unprofitable]
    var filters: [Filter] = []
    var stocks: [Stock] = []
    var filteredStocks: [Stock] = []
    var isModal = false
    
    init(modal: Bool = false) {
        isModal = modal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isModal = false
    }
    
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
            dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "list", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ListViewController else { return }
        destination.stocks = filteredStocks
    }
}
