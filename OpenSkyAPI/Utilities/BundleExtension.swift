//
//  BundleExtension.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/30/23.
//

import Foundation

extension Bundle {
    var loggerID: String { bundleIdentifier ?? description }

    static func loggerID(for aClass: AnyClass) -> String {
        Bundle(for: aClass).loggerID
    }
}
