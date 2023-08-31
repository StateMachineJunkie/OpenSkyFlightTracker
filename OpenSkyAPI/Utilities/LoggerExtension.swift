//
//  LoggerExtension.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/30/23.
//

import Foundation
import os.log

extension Logger {
    static func logger<T>(for type: T.Type) -> Logger {

        if let aClass = T.self as? AnyClass {
            let subsystem = Bundle.loggerID(for: aClass)
            return Logger(subsystem: subsystem, category: String(describing: aClass))
        } else {
            return Logger(subsystem: "com.cdellc.OpenSkyAPI", category: String(describing: T.self))
        }
    }
}
