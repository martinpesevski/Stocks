//
//  ContainerViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.9.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import UIKit

class ContainerViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([ResearchViewController(), WatchlistViewController(), ProfileViewController()], animated: true)
        
        tabBar.items?[0].image = UIImage(named: "research")
        tabBar.items?[1].image = UIImage(named: "watchlist")
        tabBar.items?[2].image = UIImage(named: "profile")
    }
    
    func onLogOut() {
        AuthenticationManager.logOut()
        navigationController?.viewControllers = [WelcomeViewController()]
    }
}
