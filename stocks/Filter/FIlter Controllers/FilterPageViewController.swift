//
//  FilterPageViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/3/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class DoneButton: UIButton {
    init(title: String = "Done") {
        super.init(frame: .zero)
        backgroundColor = UIColor.systemGreen
        layer.cornerRadius = 5
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FilterPageViewController: ViewController {
    lazy var header = UILabel(font: UIFont.systemFont(ofSize: 30, weight: .bold))
    lazy var content = ScrollableStackView(views: [header], alignment: .fill, spacing: 10,
                                   layoutInsets: UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0))

    lazy var button: DoneButton = {
        let btn = DoneButton()
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(onDone), for: .touchUpInside)
        return btn
    }()
    
    @objc func onDone() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
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
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(view.layoutMarginsGuide).inset(20)
            make.height.equalTo(70)
        }
    }
}
