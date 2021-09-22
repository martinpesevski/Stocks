//
//  LoginViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 4/27/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: ViewController {
    lazy var titleLabel = UILabel(text: "Welcome back!", font: UIFont.systemFont(ofSize: 40, weight: .bold), alignment: .center)
    
    lazy var email: StyledTextField = {
        let tv = StyledTextField()
        tv.placeholder = "Email"
        tv.delegate = self
        tv.returnKeyType = .next
        tv.becomeFirstResponder()
        return tv
    }()
    
    lazy var password: StyledTextField = {
        let tv = StyledTextField()
        tv.placeholder = "Password"
        tv.isSecureTextEntry = true
        tv.textContentType = .password
        tv.delegate = self
        tv.returnKeyType = .done
        return tv
    }()
    
    lazy var logIn: AccessoryView = {
        let v =  AccessoryView("Log in")
        v.backgroundColor = UIColor.systemGreen
        v.button.addTarget(self, action: #selector(onLogIn), for: .touchUpInside)
        v.title.textAlignment = .center
        return v
    }()
    
    lazy var content: ScrollableStackView = {
        let l = ScrollableStackView(views: [titleLabel, email, password], spacing: 20, layoutInsets: UIEdgeInsets(top: 100, left: 20, bottom: 40, right: 20))
        l.setCustomSpacing(50, after: titleLabel)
        
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(content)
        view.addSubview(logIn)
        content.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(logIn.snp.top)
        }
        logIn.snp.makeConstraints { make in make.bottom.leading.trailing.equalTo(view.layoutMarginsGuide).inset(20) }
    }
    
    @objc func onLogIn() {
        guard let email = email.text, !email.isEmpty else {
            showOKAlert(title: "Email cannot be empty", message: nil)
            return
        }
        guard let password = password.text, !password.isEmpty else {
            showOKAlert(title: "Password cannot be empty", message: nil)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let self = self else { return }
          if let error = error {
            self.showOKAlert(title: "Log in failed", message: error.localizedDescription)
              print("error sign up: \(error.localizedDescription)")
          } else if authResult != nil {
              self.navigationController?.viewControllers = [ContainerViewController()]
          }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == email {
            password.becomeFirstResponder()
        } else {
            onLogIn()
        }
        
        return true
    }
}
