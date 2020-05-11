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
