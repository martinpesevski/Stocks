//
//  SignUpViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: ViewController {
    lazy var email: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Email"
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
    
    lazy var content = ScrollableStackView(views: [email, password, confirmPassword], spacing: 10)
    
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
        guard let email = email.text, let password = password.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("error sign up: \(error.localizedDescription)")
            } else if let res = authResult {
                DatabaseManager.shared.usersHandle.child(res.user.uid)
                    .setValue(["username": res.user.displayName ?? "",
                               "subscribed": false,
                               "subscriptionEndDate": ""])

                self.navigationController?.viewControllers = [FilterViewController(viewModel: StocksViewModel())]
            }
        }
    }
}
