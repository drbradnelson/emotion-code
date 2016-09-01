//
//  DictionaryExtensions.swift
//  EmotionCode
//
//  Created by Andre Lami on 01/09/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func mergeWith(dictionary: Dictionary) {
        dictionary.forEach { self.updateValue($1, forKey: $0) }
    }
}
