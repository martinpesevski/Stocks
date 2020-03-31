//
//  GrowthTable.swift
//  stocks
//
//  Created by Martin Peshevski on 3/31/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class GrowthTable: UIStackView {
    var keyMetrics: KeyMetricsArray? {
        didSet {
            guard let keyMetrics = keyMetrics, let metrics = keyMetrics.metrics else { return }
            isHidden = false
            
            for metric in metrics {
                let cell = GrowthTableCell(metric: metric)
                insertArrangedSubview(cell, at: arrangedSubviews.count - 2)
                cellsArray.append(cell)
            }

            if let pastGrowth = keyMetrics.averageOCFGrowth {
                pastGrowthNumber.text = String(format: "%.2f%%", pastGrowth * 100)
                let futureGrowth = pastGrowth < 0.15 ? pastGrowth : 0.15
                futureGrowthNumber.text = String(format: "%.2f%%", futureGrowth * 100)
            }
        }
    }

    var cellsArray: [GrowthTableCell] = []

    lazy var titleLabel = UILabel(text: "OCF growth per share", font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var pastGrowth: UILabel = {
        let label = UILabel(text: "past average OCF growth per year:")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    lazy var pastGrowthNumber = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold), alignment: .right)
    lazy var pastGrowthStack = UIStackView.init(views: [pastGrowth, pastGrowthNumber], axis: .horizontal, spacing: 10)
    lazy var futureGrowth: UILabel = {
        let label = UILabel(text: "estimated future average OCF growth per year:")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    lazy var futureGrowthNumber = UILabel(font: UIFont.systemFont(ofSize: 20, weight: .bold), alignment: .right)
    lazy var futureGrowthStack = UIStackView.init(views: [futureGrowth, futureGrowthNumber], axis: .horizontal, spacing: 10)

    init() {
        super.init(frame: .zero)
        isHidden = true
        addArrangedSubview(titleLabel)

        addArrangedSubview(pastGrowthStack)
        addArrangedSubview(futureGrowthStack)

        axis = .vertical
        spacing = 10

        titleLabel.backgroundColor = .darkGray
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GrowthTableCell: UIStackView {
    var metric: KeyMetrics
    lazy var dateLabel = UILabel(font: UIFont.systemFont(ofSize: 15))
    lazy var ocfNumber = UILabel(font: UIFont.systemFont(ofSize: 15), alignment: .right)

    init(metric: KeyMetrics) {
        self.metric = metric
        super.init(frame: .zero)

        addArrangedSubview(dateLabel)
        addArrangedSubview(ocfNumber)
        axis = .horizontal
        spacing = 10
        layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        isLayoutMarginsRelativeArrangement = true

        dateLabel.text = metric.date
        if let ocf = metric.ocf { ocfNumber.text = String(format: "$%.5f", ocf) } else { ocfNumber.text = "N/A" }

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}