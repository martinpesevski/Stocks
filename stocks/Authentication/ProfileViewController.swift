//
//  ProfileViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 21.9.21.
//  Copyright © 2021 Martin Peshevski. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: ViewController {
    lazy var profileImage: UIImageView = {
        let l = UIImageView(image: UIImage(named: "profile"))
        return l
    }()
    
    lazy var nameLabel = UILabel(text: AuthenticationManager.username, font: UIFont.boldSystemFont(ofSize: 20), alignment: .center, color: .label)
    lazy var signOutButton: UIButton = {
       let l = UIButton()
        l.setTitle("Log out", for: .normal)
        l.setTitleColor(.red, for: .normal)
        l.addTarget(self, action: #selector(onSignOut), for: .touchUpInside)
        return l
    }()
    
    lazy var contentStack = UIStackView(views: [profileImage, nameLabel, signOutButton, UIView()],
                                        axis: .vertical,
                                        distribution: .fill,
                                        alignment: .center,
                                        spacing: 20,
                                        layoutInsets: UIEdgeInsets(top: 50, left: 20, bottom: 20, right: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    @objc func onSignOut() {
        guard let parent = parent as? ContainerViewController else { return }
        parent.onLogOut()
    }
}
