//
//  PreferredMetricsTable.swift
//  Stocker
//
//  Created by Martin Peshevski on 9/2/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit

protocol PreferredMetricsDelegate {
    func shouldShow(viewController: UIViewController)
}

let defaultMetricTypes: [AnyMetricType] = [
    AnyMetricType(IncomeStatementMetricType.eps),
    AnyMetricType(IncomeStatementMetricType.grossProfit),
    AnyMetricType(FinancialRatioMetricType.priceEarningsRatio),
    AnyMetricType(FinancialRatioMetricType.currentRatio),
    AnyMetricType(FinancialRatioMetricType.priceToSalesRatio),
    AnyMetricType(FinancialRatioMetricType.priceEarningsToGrowthRatio),
    AnyMetricType(FinancialRatioMetricType.returnOnCapitalEmployed),
    AnyMetricType(BalanceSheetMetricType.totalCurrentAssets),
    AnyMetricType(BalanceSheetMetricType.totalLiabilities)]

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
    
    let interItemSpacing: CGFloat = 8
    let cellHeight: CGFloat = 60
    
    var delegate: PreferredMetricsDelegate?

    lazy var metrics: [AnyMetric] = {
        var arr: [AnyMetric] = []
        let preferredMetrics = UserDefaultsManager.shared.preferredMetrics
        for metricType in preferredMetrics {
            if let metric = stock.metric(metricType: metricType).quarterly { arr.append(metric) }
        }
        return arr
    }()
    
    var contentHeight: CGFloat {
        (CGFloat(metrics.count) / 2).rounded(.up) * (cellHeight + interItemSpacing)
    }
        
    init(stock: Stock) {
        self.stock = stock
        super.init(frame: .zero)
        axis = .vertical
        spacing = 10
        addArrangedSubview(titleLabel)
        addArrangedSubview(collectionView)
        collectionView.snp.makeConstraints { make in make.height.equalTo(contentHeight) }
    }
    
    func update() {
        var arr: [AnyMetric] = []
        let preferredMetrics = UserDefaultsManager.shared.preferredMetrics
        for metricType in preferredMetrics {
            if let metric = stock.metric(metricType: metricType).quarterly { arr.append(metric) }
        }
        metrics = arr
        collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let metric = metrics[indexPath.row]
        let mappedAnual: [PeriodicFinancialModel]
        let mappedQuarterly: [PeriodicFinancialModel]
        
        if stock.incomeStatementsAnnual?[safe: 0]?.metrics.contains(metric) ?? false {
            mappedAnual = stock.incomeStatementsAnnual?.percentageIncrease(metric: metric) ?? []
            mappedQuarterly = stock.incomeStatementsQuarterly?.percentageIncrease(metric: metric) ?? []
        } else if stock.balanceSheetsAnnual?[safe: 0]?.metrics.contains(metric) ?? false {
            mappedAnual = stock.balanceSheetsAnnual?.percentageIncrease(metric: metric) ?? []
            mappedQuarterly = stock.balanceSheetsQuarterly?.percentageIncrease(metric: metric) ?? []
        } else if stock.cashFlowsAnnual?[safe: 0]?.metrics.contains(metric) ?? false {
            mappedAnual = stock.cashFlowsAnnual?.percentageIncrease(metric: metric) ?? []
            mappedQuarterly = stock.cashFlowsQuarterly?.percentageIncrease(metric: metric) ?? []
        } else if stock.keyMetricsAnnual?[safe: 0]?.metrics.contains(metric) ?? false {
            mappedAnual = stock.keyMetricsAnnual?.percentageIncrease(metric: metric) ?? []
            mappedQuarterly = stock.keyMetricsQuarterly?.percentageIncrease(metric: metric) ?? []
        } else if stock.financialRatiosAnnual?[safe: 0]?.metrics.contains(metric) ?? false {
            mappedAnual = stock.financialRatiosAnnual?.percentageIncrease(metric: metric) ?? []
            mappedQuarterly = stock.financialRatiosQuarterly?.percentageIncrease(metric: metric) ?? []
        } else {
            return
        }
        
        let vc = PeriodicValueChangeViewController(ticker: stock.ticker.symbol, metricType: metric, periodicChangeAnnual: mappedAnual, periodicChangeQuarterly: mappedQuarterly)
        
        delegate?.shouldShow(viewController: vc)
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
