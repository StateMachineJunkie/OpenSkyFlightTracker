// 
// TimeIntervalExtension.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 10/10/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import Foundation

extension TimeInterval {
    static func seconds(value: Int) -> TimeInterval { TimeInterval(value) }
    static func minutes(value: Int) -> TimeInterval { TimeInterval(value) * 60.0 }
    static func hours(value: Int) -> TimeInterval { TimeInterval(value) * 3_600.0 }
    static func days(value: Int) -> TimeInterval { TimeInterval(value) * 24.0 * 3_600.0 }
}
