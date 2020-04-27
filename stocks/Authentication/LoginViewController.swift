//
//  LoginViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class LoginViewController: ViewController {
    lazy var username: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Username"
        return tv
    }()
    
    lazy var password: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Password"
        tv.isSecureTextEntry = true
        tv.textContentType = .password
        return tv
    }()
    
    lazy var logIn: AccessoryView = {
        let v =  AccessoryView("Log in")
        v.backgroundColor = UIColor.systemGreen
        v.button.addTarget(self, action: #selector(onLogIn), for: .touchUpInside)
        return v
    }()
    
    lazy var content = ScrollableStackView(views: [username, password], spacing: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        view.addSubview(logIn)
        content.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(logIn.snp.top).inset(10)
        }
        logIn.snp.makeConstraints { make in make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10) }
    }
    
    @objc func onLogIn() {
        
    }
}
