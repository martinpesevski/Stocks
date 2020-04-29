//
//  AuthenticationManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//
import Firebase
import FirebaseUI

import Foundation

class AuthenticationManager: NSObject, FUIAuthDelegate {
    let authUI: FUIAuth?
    
    override init() {
        FirebaseApp.configure()
        authUI = FUIAuth.defaultAuthUI()
        super.init()
        
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth()
        ]
        authUI?.providers = providers
    }
    
    var authViewController: UINavigationController? {
        let vc = authUI?.authViewController()
        return vc
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let a =
        let auth = FUIAuth(uiWith: Auth())
        return WelcomeViewController(authUI: <#T##FUIAuth#>)
    }
}
