//
//  AuthenticationManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//
import Firebase
import Foundation
import FirebaseAuth

class AuthenticationManager: NSObject {
    override init() {
        FirebaseApp.configure()
        super.init()
    }
    
    var authViewController: UINavigationController? {
        guard Auth.auth().currentUser != nil else {
            let welcome = WelcomeViewController()
            let nav = UINavigationController(rootViewController: welcome)
            return nav
        }

        let list = FilterViewController()
        let nav = UINavigationController(rootViewController: list)
        return nav
    }
}
