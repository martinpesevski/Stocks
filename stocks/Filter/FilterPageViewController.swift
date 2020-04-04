//
//  FilterPageViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class FilterPageViewController: ViewController {
    lazy var header = UILabel(font: UIFont.systemFont(ofSize: 30, weight: .bold))
    lazy var content = ScrollableStackView(views: [header], alignment: .fill, spacing: 10,
                                   layoutInsets: UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0))

    lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.systemGreen
        btn.layer.cornerRadius = 5
        btn.setTitle("Done", for: .normal)
        btn.addTarget(self, action: #selector(onDone), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return btn
    }()
    
    @objc func onDone() {
        //overrirde in subclasses
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(content)
        view.addSubview(button)
        
        content.setCustomSpacing(50, after: header)
        
        content.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(button)
        }
        button.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(70)
        }
    }
}
