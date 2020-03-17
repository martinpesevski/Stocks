//
//  Util.swift
//  stocks
//
//  Created by Martin Peshevski on 3/17/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

protocol StockIdentifiable {
    static func stockIdentifier(_ ticker: String) -> String
}

extension String {
    var floatValue: Float? { Float(self) }
}
