// 
// BundleExtension.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/17/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import Foundation

extension Bundle {
    var loggerID: String { bundleIdentifier ?? description }

    static func loggerID(for aClass: AnyClass) -> String {
        Bundle(for: aClass).loggerID
    }
}
