//
//  WelcomeViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class WelcomeViewController: ViewController {
    lazy var titleLabel = UILabel(text: "Welcome to Stocker!", font: UIFont.systemFont(ofSize: 40, weight: .bold), alignment: .center)
    
    lazy var signUp: AccessoryView = {
        let v =  AccessoryView("Sign up")
        v.backgroundColor = UIColor.systemGreen
        v.button.addTarget(self, action: #selector(onSignUp), for: .touchUpInside)
        v.title.textAlignment = .center
        return v
    }()
    lazy var logIn: AccessoryView = {
        let v = AccessoryView("Log in")
        v.button.addTarget(self, action: #selector(onLogIn), for: .touchUpInside)
        v.title.textAlignment = .center
        return v
    }()
    
    lazy var content = UIStackView(views: [titleLabel, UIView(), signUp, logIn], axis: .vertical, spacing: 10, layoutInsets: UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        content.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide) }
    }
    
    @objc func onLogIn() {
        show(LoginViewController(), sender: nil)
    }
    
    @objc func onSignUp() {
        show(SignUpViewController(), sender: nil)
    }
}
