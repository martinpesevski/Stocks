//
//  PreferredMetricsTable.swift
//  Stocker
//
//  Created by Martin Peshevski on 9/2/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

class PreferredMetricCell: UICollectionViewCell {
    lazy var titleLabel = UILabel(font: UIFont.systemFont(ofSize: 15))
    lazy var valueLabel = UILabel(font: UIFont.systemFont(ofSize: 15, weight: .bold), alignment: .right)
    lazy var content = UIStackView(views: [titleLabel, valueLabel], axis: .horizontal, spacing: 10,
                                   layoutInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(content)
        content.snp.makeConstraints{ make in make.edges.equalToSuperview() }
        backgroundColor = .systemGray6
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    func setup(metric: Metric) {
        titleLabel.text = metric.text
        valueLabel.text = metric.stringValue.roundedWithAbbreviations
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PreferredMetricsTable: UIStackView {
    
    lazy var titleLabel = UILabel(text: "Key metrics", font: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var collectionView: UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        col.delegate = self
        col.dataSource = self
        col.register(PreferredMetricCell.self, forCellWithReuseIdentifier: "preferredMetricCell")
        col.backgroundColor = .clear
        
        return col
    }()
    var stock: Stock
    lazy var defaultMetrics: [Metric] = {
        var arr: [Metric] = []
        if let firstIncome = stock.incomeStatementsQuarterly?.financials?.first {
            arr.append(firstIncome.eps)
            arr.append(firstIncome.grossMargin)
        }
        
        if let firstRatios = stock.financialRatiosQuarterly?.first {
            arr.append(firstRatios.currentRatio)
            arr.append(firstRatios.priceEarningsRatio)
            arr.append(firstRatios.priceToSalesRatio)
            arr.append(firstRatios.priceEarningsToGrowthRatio)
            arr.append(firstRatios.returnOnCapitalEmployed)
        }
        
        if let firstBalance = stock.balanceSheetsQuarterly?.financials?.first {
            arr.append(firstBalance.totalCurrentAssets)
            arr.append(firstBalance.totalLiabilities)
        }
        
        return arr
    }()
    
    let interItemSpacing: CGFloat = 8
    let cellHeight: CGFloat = 60

    var metrics: [Metric] = []
    var contentHeight: CGFloat {
        (CGFloat(metrics.count) / 2).rounded(.up) * (cellHeight + interItemSpacing)
    }
        
    init(stock: Stock, items: [Metric]?) {
        self.stock = stock
        super.init(frame: .zero)
        if let items = items { self.metrics = items } else { self.metrics = defaultMetrics }
        axis = .vertical
        spacing = 10
        addArrangedSubview(titleLabel)
        addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { make in make.height.equalTo(contentHeight) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PreferredMetricsTable: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metrics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preferredMetricCell", for: indexPath) as? PreferredMetricCell ?? PreferredMetricCell()
        cell.setup(metric: metrics[indexPath.row])
        return cell
    }
}

extension PreferredMetricsTable: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + interItemSpacing
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / 2).rounded(.down)
        return CGSize(width: itemWidth, height: cellHeight)
    }
}
