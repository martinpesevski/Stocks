//
//  ResearchViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.9.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import UIKit

class ResearchViewController: UINavigationController {
    override func viewDidLoad() {
        addChild(FilterViewController(viewModel: StocksViewModel()))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.isHidden = true
    }
}
