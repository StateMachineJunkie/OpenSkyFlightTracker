// 
// StateVectorExtension.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/21/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import CoreLocation
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

extension OpenSkyService.StateVector: GeoTrackable {

    var name: String {
        displayFlightName
    }

    // For our application, vectors missing LAT, LON, or ALT are not useful and should have been filtered on the way in.
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(latitude!), longitude: Double(longitude!))
    }
}
