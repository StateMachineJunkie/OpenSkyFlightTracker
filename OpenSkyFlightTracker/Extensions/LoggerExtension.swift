// 
// LoggerExtension.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/15/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import Foundation
import os.log

extension Logger {
    static func logger<T>(for type: T.Type) -> Logger {

        if let aClass = T.self as? AnyClass {
            let subsystem = Bundle.loggerID(for: aClass)
            return Logger(subsystem: subsystem, category: String(describing: aClass))
        } else {
            return Logger(subsystem: "com.cdellc.OpenSkyFlightTracker", category: String(describing: T.self))
        }
    }
}
