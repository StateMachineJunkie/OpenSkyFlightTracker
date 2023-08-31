//
//  DictionaryExtension.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/29/23.
//

import Foundation

extension Dictionary where Key == String, Value: Any {
    /// Converts all dictionary key/value pairs into query items.
    /// - Note We only expect the four basic types (Bool, Int, Double, and String) to be used as parameters.
    ///        Any other type included in the parameter dictionary will be filtered out.
    public var openSkyQueryItems: [URLQueryItem]? {
        guard count > 0 else { return nil }

        let queryItems: [URLQueryItem] = self.compactMap { (key, value) in
            let stringValue: String

            if let value = value as? String {
                stringValue = value
            } else if let value = value as? Double {
                stringValue = String(value)
            } else if let value = value as? Int {
                stringValue = String(value)
            } else if let value = value as? Bool {
                stringValue = value ? "true" : "false"
            } else {
                return nil
            }

            return URLQueryItem(name: key, value: stringValue)
        }
        return queryItems
    }
}

extension Array where Element == String {
    public var transponderQueryItems: [URLQueryItem]? {
        guard count > 0 else { return nil }

        let queryItems: [URLQueryItem] = self.compactMap { (stringValue) in
            if stringValue.isICAO24 {
                return URLQueryItem(name: "icao24", value: stringValue)
            } else {
                return nil
            }
        }
        return queryItems
    }
}

extension String {
    // In order to be consider a valid ICAO-24 transponder code, the string must represent be a 24-bit lower-cased
    // hexadecimal value.
    var isICAO24: Bool {
        icao24Value() != nil
    }

    private func icao24Value() -> UInt32? {
        var accumulator: UInt32 = 0
        for c in self {
            accumulator *= 16
            guard let hexDigitValue = c.hexDigitValue else { return nil }
            accumulator += UInt32(hexDigitValue)
        }
        guard accumulator < 1 << 24 else { return nil }
        return accumulator
    }
}
