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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        largeCap.setup(filter: .largeCap)
        midCap.setup(filter: .midCap)
        smallCap.setup(filter: .smallCap)
        profitable.setup(filter: .profitable)
        unprofitable.setup(filter: .unprofitable)
    }
}
