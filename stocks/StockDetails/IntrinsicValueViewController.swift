//
//  IntrinsicValueViewController.swift
//  Stocker
//
//  Created by Martin Peshevski on 8/23/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class IntrinsicValueViewController: ViewController, UITextFieldDelegate {
    var intrinsicValue: IntrinsicValue
    var stock: Stock
    
    lazy var header = StockInfoHeader()

    lazy var growthLabel = UILabel(text: "Expected 10 year growth rate (per year):", font: UIFont.systemFont(ofSize: 15), color: .label)
    lazy var growthRateButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = UIColor.systemGray5
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(changeGrowthRate), for: .touchUpInside)
        
        return btn
    }()
    lazy var growthRateStack = UIStackView(views: [growthLabel, growthRateButton], axis: .horizontal, spacing: 10)
    
    lazy var discountRateLabel = UILabel(text: "Discount rate:", font: UIFont.systemFont(ofSize: 15), color: .label)
    lazy var discountRateButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = UIColor.systemGray5
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(changeDiscountRate), for: .touchUpInside)
        
        return btn
    }()
    lazy var discountRateStack = UIStackView(views: [discountRateLabel, discountRateButton], axis: .horizontal, spacing: 10)
    
    lazy var content = UIStackView(views: [header, growthRateStack, discountRateStack, UIView()], axis: .vertical, alignment: .fill, spacing: 15, layoutInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    
    lazy var growthAlert: UIAlertController = {
        let alert = UIAlertController.init(title: "Enter growth rate %", message: "What is the expected growth rate per year for the next 10 years for this company?", preferredStyle: .alert)
        alert.addTextField { field in
            self.growthAlertTextField = field
            field.delegate = self
            field.keyboardType = .decimalPad
            field.tag = 0
            let numberToolbar = UIToolbar()
            var accessories : [UIBarButtonItem] = []
            let plusMinus = UIBarButtonItem(title: "+/-", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.plusMinusPressed))
            plusMinus.tintColor = .label
            accessories.append(plusMinus)
            numberToolbar.items = accessories
            numberToolbar.sizeToFit()
            field.inputAccessoryView = numberToolbar
        }
        alert.addAction(UIAlertAction.init(title: "Update", style: .default, handler: nil))
        
        return alert
    }()
    
    var growthAlertTextField: UITextField?
    
    lazy var discountRateAlert: UIAlertController = {
        let alert = UIAlertController.init(title: "Select discount rate %", message: "What is the discount rate you would like to use for this calculation?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction.init(title: "Low risk (\(IntrinsicValue.DiscountRate.low.percentageString))", style: .default, handler: { action in
            self.intrinsicValue.originalDiscountRate = .low
            self.refresh()
        }))
        alert.addAction(UIAlertAction.init(title: "Medium risk (\(IntrinsicValue.DiscountRate.medium.percentageString))", style: .default, handler: { action in
            self.intrinsicValue.originalDiscountRate = .medium
            self.refresh()
        }))
        alert.addAction(UIAlertAction.init(title: "High risk (\(IntrinsicValue.DiscountRate.high.percentageString))", style: .default, handler: { action in
            self.intrinsicValue.originalDiscountRate = .high
            self.refresh()
        }))

        return alert
    }()
    
    init(stock: Stock) {
        
        self.stock = stock
        self.intrinsicValue = stock.intrinsicValue ?? IntrinsicValue(price: 0, cashFlow: 0, growthRate: 0, discountRate: .low)
        
        super.init(nibName: nil, bundle: nil)

        header.setup(stock: stock)
        self.title = stock.ticker.detailName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(content)
        content.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(50)
        }
        content.setCustomSpacing(25, after: header)
        refresh()
    }
    
    func refresh() {
        discountRateButton.setTitle(intrinsicValue.originalDiscountRate.percentageString, for: .normal)
        growthRateButton.setTitle("\(intrinsicValue.growthRate * 100)".roundedWithAbbreviations.formatted(.percentage), for: .normal)
        stock.intrinsicValue = intrinsicValue
        header.setup(stock: stock)
    }
    
    @objc
    func changeGrowthRate() {
        present(growthAlert, animated: true, completion: nil)
    }
    
    @objc
    func changeDiscountRate() {
        present(discountRateAlert, animated: true, completion: nil)
    }
    
    @objc
    func plusMinusPressed() {
        guard let currentText = self.growthAlertTextField?.text else {
            return
        }
        if currentText.hasPrefix("-") {
            let offsetIndex = currentText.index(currentText.startIndex, offsetBy: 1)
            let substring = currentText[offsetIndex...]  //remove first character
            self.growthAlertTextField?.text = String(substring)
        }
        else {
            self.growthAlertTextField?.text = "-" + currentText
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let growthRate = textField.text?.doubleValue else { return }
        intrinsicValue.growthRate = growthRate / 100
        refresh()
        growthAlert.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
