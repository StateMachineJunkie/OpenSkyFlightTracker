// 
// StateVectorExtension.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/21/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import Foundation
import OpenSkyAPI

// Display extensions for presentation layer
extension OpenSkyService.StateVector {
    var displayAltitude: String { isOnGround ? "On the ground" : altitude == nil ? "Unknown" : "\(UInt(round(altitude!))) meters" }
    var displayFlightName: String { callsign == nil ? "Unknown" : callsign! }
    var displayHeading: String { trueTrack == nil ? "Unknown" : "\(UInt(round(trueTrack!)))º" }
    var displayTransponder: String { icao24.uppercased() }
    var displayVelocity: String { velocity == nil ? "Unknown" : "\(UInt(round(velocity!))) meters/second" }
}
