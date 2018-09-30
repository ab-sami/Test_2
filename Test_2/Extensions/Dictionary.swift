//
//  Dictionary.swift
//  Tsetatonsisith
//
//  Created by Abdul Sami on 20/09/2018.
//  Copyright © 2018 Abdul Sami. All rights reserved.
//

import Foundation

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

extension Dictionary where Key == String, Value == Any {
    mutating func append<Key:RawRepresentable>(_ key:Key, _ value:Any?) where Key.RawValue == String {
        if let value = value {
            self[key.rawValue] = value
        }
    }
}

extension Dictionary where Value: Equatable {
    func valueForKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
