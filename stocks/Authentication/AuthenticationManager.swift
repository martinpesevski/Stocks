//
//  AuthenticationManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//
import Firebase
import UIKit
import FirebaseAuth

class AuthenticationManager: NSObject {
    override init() {
        FirebaseApp.configure()
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "hasRunBefore") {
            try? Auth.auth().signOut()
            userDefaults.set(true, forKey: "hasRunBefore")
        }
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
