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
        tv.returnKeyType = .next
        tv.delegate = self
        tv.becomeFirstResponder()
        return tv
    }()
    
    lazy var password: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Password"
        tv.isSecureTextEntry = true
        tv.textContentType = .password
        tv.returnKeyType = .next
        tv.delegate = self
        return tv
    }()
    
    lazy var confirmPassword: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Confirm password"
        tv.isSecureTextEntry = true
        tv.textContentType = .password
        tv.returnKeyType = .done
        tv.delegate = self
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

                self.navigationController?.viewControllers = [ContainerViewController()]
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == email {
            password.becomeFirstResponder()
        } else if textField == password {
            confirmPassword.becomeFirstResponder()
        } else {
            onSignUp()
        }
        return true
    }
}
