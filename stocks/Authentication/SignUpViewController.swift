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
    lazy var titleLabel = UILabel(text: "Begin your journey towards financial independence!", font: UIFont.systemFont(ofSize: 40, weight: .bold), alignment: .center)
    lazy var subtitleLabel = UILabel(text: "Let's get started.", font: UIFont.systemFont(ofSize: 20), alignment: .center)

    lazy var email: StyledTextField = {
        let tv = StyledTextField()
        tv.placeholder = "Email"
        tv.returnKeyType = .next
        tv.delegate = self
        tv.becomeFirstResponder()
        return tv
    }()
    
    lazy var password: StyledTextField = {
        let tv = StyledTextField()
        tv.placeholder = "Password"
        tv.isSecureTextEntry = true
        tv.textContentType = .password
        tv.returnKeyType = .next
        tv.delegate = self
        return tv
    }()
    
    lazy var confirmPassword: StyledTextField = {
        let tv = StyledTextField()
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
        v.title.textAlignment = .center
        return v
    }()
    
    lazy var content: ScrollableStackView = {
        let l = ScrollableStackView(views: [titleLabel, subtitleLabel, email, password, confirmPassword], spacing: 20, layoutInsets: UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 20))
        l.setCustomSpacing(50, after: subtitleLabel)
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        view.addSubview(signUp)
        content.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(signUp.snp.top)
        }
        signUp.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide).inset(20)
            make.bottom.equalTo(view.layoutMarginsGuide).inset(40)
        }
    }
    
    @objc func onSignUp() {
        guard let email = email.text, !email.isEmpty else {
            showOKAlert(title: "Email cannot be empty", message: nil)
            return
        }
        guard let password = password.text, !password.isEmpty else {
            showOKAlert(title: "Password cannot be empty", message: nil)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.showOKAlert(title: "sign up failed", message: error.localizedDescription)
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
