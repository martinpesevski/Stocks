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
    lazy var image: UIImageView = {
          let tv = UIImageView()
          tv.image = UIImage(named: "wallpaper_welcome")
          return tv
    }()
    
    
    
    lazy var email: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Email"
        tv.delegate = self
        tv.textAlignment = .center
        tv.autocapitalizationType = .none
        tv.layer.cornerRadius = 10
        tv.returnKeyType = .next
        tv.font = UIFont(name: "San Francisco", size: 25)
        tv.font = UIFont.systemFont(ofSize: 25)
        
        tv.becomeFirstResponder()
        return tv
    }()
    
    lazy var password: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Password"
        tv.isSecureTextEntry = true
        tv.font = UIFont.systemFont(ofSize: 25)
        tv.textAlignment = .center
        tv.textContentType = .password
        tv.layer.cornerRadius = 10
        tv.delegate = self
        tv.returnKeyType = .done
        return tv
    }()
    
    lazy var logIn: AccessoryView = {
        let v =  AccessoryView("Log in")
        v.backgroundColor = UIColor.systemGreen
        v.button.addTarget(self, action: #selector(onLogIn), for: .touchUpInside)
        return v
    }()
    
    lazy var content = ScrollableStackView(views: [email, password], spacing: 40 )
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        view.addSubview(image)
        view.addSubview(content)
        view.addSubview(logIn)
        
        image.snp.makeConstraints { (make) in
            make.size.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
       
        
        content.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(300)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(logIn.snp.top).inset(10)
        }
        
        logIn.snp.makeConstraints { make in make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            
        }
    }
    
    
    @objc func onLogIn() {
        guard let email = email.text, let password = password.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let self = self else { return }
          if let error = error {
              print("error sign up: \(error.localizedDescription)")
          } else if authResult != nil {
              self.navigationController?.viewControllers = [FilterViewController(viewModel: StocksViewModel())]
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
