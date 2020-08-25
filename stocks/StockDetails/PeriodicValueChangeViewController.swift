//
//  PeriodicValueChangeViewController.swift
//  stocks
//
//  Created by Martin Peshevski on 4/14/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

struct PeriodicFinancialModel {
    var period: String
    var value: String
    var percentChange: Double

    var percentChangeString: String { return String.init(format: "%.2f%%", percentChange) }
    var percentColor: UIColor { return percentChange < 0 ? UIColor.systemRed : UIColor.systemGreen }
    var image: UIImage { return percentChange < 0 ? (UIImage(named: "down") ?? UIImage()).withRenderingMode(.alwaysTemplate):
        (UIImage(named: "up") ?? UIImage()).withRenderingMode(.alwaysTemplate) }
}

class PercentChangeKeyValueView: KeyValueView {
    lazy var percentLabel: UILabel = {
        let lbl = UILabel(font: UIFont.systemFont(ofSize: 12), alignment: .right)
        lbl.setContentCompressionResistancePriority(.required, for: .horizontal)
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lbl
    }()
    lazy var percentImage: UIImageView = {
        let img = UIImageView()
        img.snp.makeConstraints { make in make.width.height.equalTo(24) }
        return img
    }()
    lazy var percentStack = UIStackView(views: [UIView(), percentImage, percentLabel], axis: .horizontal)

    lazy var valueStack = UIStackView(views: [], axis: .vertical, spacing: 5)
    init(model: PeriodicFinancialModel) {
        super.init(key: model.period, value: model.value.roundedWithAbbreviations)
        valueLabel.removeFromSuperview()
        percentLabel.text = model.percentChangeString
        percentLabel.textColor = model.percentColor
        percentImage.tintColor = model.percentColor
        percentImage.image = model.image

        valueStack.addArrangedSubview(valueLabel)
        valueStack.addArrangedSubview(percentStack)

        addArrangedSubview(valueStack)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PeriodicValueChangeViewController: StackViewController {
    init(ticker: String, metricType: String, periodicChange: [PeriodicFinancialModel]) {
        super.init()
        titleView.text = ticker
        subtitleView.text = metricType

        for metric in periodicChange {
            let cell = PercentChangeKeyValueView(model: metric)
            content.addArrangedSubview(cell)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
