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
    
    var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
class DataParser {
    static func parseJson<T: Codable>(type: T.Type, data: Data, completion: @escaping (T?, Error?) -> ()) {
        do {
            let object: T = try JSONDecoder().decode(T.self, from: data)
            completion(object, nil)
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
            completion(nil, DecodingError.dataCorrupted(context))
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(nil, DecodingError.keyNotFound(key, context))
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(nil, DecodingError.valueNotFound(value, context))
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(nil, DecodingError.typeMismatch(type, context))
        } catch {
            print("error: ", error)
        }
    }

    static func parseTJson<T: Codable>(type: T.Type, data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(T.self, from: data)
            print(object as Any)
            return object
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        return nil
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

extension UIViewController {
    func showOKAlert(title: String, message: String?) {
        let l = UIAlertController(title: title, message: message, preferredStyle: .alert)
        l.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(l, animated: true, completion: nil)
    }
}

extension UISegmentedControl {
    func selectSegmentWithTitle(_ title: String?) {
        guard let title = title else {
            selectedSegmentIndex = UISegmentedControl.noSegment
            return
        }
        
        for i in 0..<numberOfSegments where titleForSegment(at: i) == title {
            selectedSegmentIndex = i
            return
        }
        selectedSegmentIndex = UISegmentedControl.noSegment
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
