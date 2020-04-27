//
//  SignUpViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class SignUpViewController: ViewController {
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
    
    lazy var confirmPassword: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Confirm password"
        tv.isSecureTextEntry = true
        tv.textContentType = .password
        return tv
    }()
    
    lazy var signUp: AccessoryView = {
        let v =  AccessoryView("Sign up")
        v.backgroundColor = UIColor.systemGreen
        v.button.addTarget(self, action: #selector(onSignUp), for: .touchUpInside)
        return v
    }()
    
    lazy var content = ScrollableStackView(views: [username, password, confirmPassword], spacing: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        view.addSubview(signUp)
        content.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(signUp.snp.top).inset(10)
        }
        signUp.snp.makeConstraints { make in make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10) }
    }
    
    @objc func onSignUp() {
        
    }
}
