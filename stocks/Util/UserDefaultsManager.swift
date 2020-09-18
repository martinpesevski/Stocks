//
//  UserDefaultsManager.swift
//  Stocker
//
//  Created by Martin Peshevski on 9/15/20.
//  Copyright © 2020 Martin Peshevski. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    private let kPreferredMetrics = "preferredMetrics"

    static var shared = UserDefaultsManager()
    var defaults: UserDefaults
    
    init() {
        defaults = UserDefaults.standard
    }
    
    var preferredMetrics: [AnyMetricType] {
        get {
            guard let decoded = defaults.object(forKey: kPreferredMetrics) as? Data,
                let metricTypes = try? PropertyListDecoder().decode([AnyMetricType].self, from: decoded) else
            {
                let data = (try? PropertyListEncoder().encode(defaultMetricTypes))
                defaults.set(data, forKey: kPreferredMetrics)
                return defaultMetricTypes
            }
            return metricTypes
        }
        
        set {
            let data = (try? PropertyListEncoder().encode(newValue))
            defaults.set(data, forKey: kPreferredMetrics)
        }
    }
}
