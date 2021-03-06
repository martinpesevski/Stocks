//
//  Util.swift
//  stocks
//
//  Created by Martin Peshevski on 3/17/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import UIKit
import StoreKit

protocol StockIdentifiable {
    static func stockIdentifier(_ ticker: String) -> String
}

extension String {
    var floatValue: Float? { Float(self) }
    var doubleValue: Double? { Double(self) }
    var twoDigits: String { String(format: "%.2f", self.floatValue ?? 0) }
    
    var roundedWithAbbreviations: String {
        let negative = self.first == "-"
        guard let number = Double(negative ? String(self.dropFirst()) : self) else { return self }
        let thousand = number / 1000
        let million = number / 1000000
        
        if million >= 100.0 {
            let millionRounded = (million * 10).rounded() / 10
            let formatted = ExponentRemoverFormatter.shared.string(from: NSNumber(value: millionRounded)) ?? "\(millionRounded)"
            return negative ? "-\(formatted)M" : "\(formatted)M"
        }
        else if thousand >= 100.0 {
            let thousandRounded = (thousand * 10).rounded() / 10
            let formatted = ExponentRemoverFormatter.shared.string(from: NSNumber(value: thousandRounded)) ?? "\(thousandRounded)"
            return negative ? "-\(formatted)K" : "\(formatted)K"
        }
        else {
            return "\(self)".twoDigits
        }
    }
    
    func formatted(_ metricSuffixType: MetricSuffixType) -> String {
        switch metricSuffixType {
        case .none: return self
        case .money: return "$\(self)"
        case .percentage: return "\(self)%"
        }
    }
}
class DataParser {
    static func parseJson<T: Codable>(type: T.Type, data: Data, completion: @escaping (T?, Error?) -> ()) {
        do {
            let object: T = try JSONDecoder().decode(T.self, from: data)
            completion(object, nil)
        } catch let error as NSError {
            completion(nil, error)
        }
    }

    static func parseTJson<T: Codable>(type: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension UILabel {
    convenience init(text: String? = nil, font: UIFont = UIFont.systemFont(ofSize: 15), alignment: NSTextAlignment = .left, color: UIColor = .label) {
        self.init()
        self.text = text
        self.font = font
        self.textAlignment = alignment
        self.textColor = color
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
    }
}

extension UIStackView {
    convenience init(views: [UIView], axis: NSLayoutConstraint.Axis, distribution: Distribution? = nil, alignment: Alignment? = nil, spacing: CGFloat = 0, layoutInsets: UIEdgeInsets? = nil) {
        self.init(arrangedSubviews: views)
        if let distribution = distribution { self.distribution = distribution }
        if let alignment = alignment { self.alignment = alignment }
        self.spacing = spacing
        self.axis = axis
        if let insets = layoutInsets {
            self.isLayoutMarginsRelativeArrangement = true
            self.layoutMargins = insets
        }
    }
}

extension Collection {
    subscript(safe i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}

extension UIView {
    func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = .systemGray3
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func startLoading() {
        subviews.forEach { if $0 is LoadingView { return } }
        let view = LoadingView()
        view.backgroundColor = backgroundColor
        addSubview(view)
        view.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    func finishLoading() {
        subviews.forEach { view in if view is LoadingView {
            UIView.animate(withDuration: 0.5, animations: {
                view.alpha = 0
            }, completion: { _ in
                view.removeFromSuperview()
            })
            }
        }
    }
}

extension SKProduct {
    var currencyPrice: String {
        "\(priceLocale.currencySymbol ?? "")\(price)"
    }
}

class LoadingView: UIView {
    init() {
        super.init(frame: .zero)
        let loading = UIActivityIndicatorView(style: .medium)
        loading.startAnimating()
        addSubview(loading)
        loading.snp.makeConstraints { make in make.center.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        }
    }
}

class ExponentRemoverFormatter: NumberFormatter {
    static var shared = ExponentRemoverFormatter()

    override init() {
        super.init()
        numberStyle = .decimal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StockDateFormatter: DateFormatter {
    static var shared = StockDateFormatter()

    override init() {
        super.init()
        dateFormat = "yyyy-mm-dd"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
