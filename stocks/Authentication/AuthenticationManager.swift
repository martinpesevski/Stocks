//
//  AuthenticationManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//
import Firebase
import Foundation

class AuthenticationManager: NSObject {
    override init() {
        FirebaseApp.configure()
        super.init()
    }
    
    var authViewController: UINavigationController? {
        let welcome = WelcomeViewController()
        let nav = UINavigationController(rootViewController: welcome)
        return nav
    }
}
