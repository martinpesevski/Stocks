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
    static func configure() {
        FirebaseApp.configure()
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "hasRunBefore") {
            try? Auth.auth().signOut()
            userDefaults.set(true, forKey: "hasRunBefore")
        }
    }
    
    static func logOut() {
        try? Auth.auth().signOut()
    }
    
    static var username: String {
        guard let currentUser = Auth.auth().currentUser else { return "" }
        return currentUser.displayName ?? (currentUser.email ?? "")
    }
    
    static var authViewController: UINavigationController? {
        guard Auth.auth().currentUser != nil else {
            let welcome = WelcomeViewController()
            let nav = UINavigationController(rootViewController: welcome)
            return nav
        }

        let list = ContainerViewController()
        let nav = UINavigationController(rootViewController: list)
        return nav
    }
}
