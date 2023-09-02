//
//  StringExtension.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/29/23.
//

import Foundation

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
