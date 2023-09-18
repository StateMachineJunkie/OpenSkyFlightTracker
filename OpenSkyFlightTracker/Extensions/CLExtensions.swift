// 
// CLLocationCoordinate2DExtension.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/15/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    private static let metersPerDegree = 111_111.1  // According to University of Wisconsin State Cartographer's Office.

    func latitudeWithOffset(latitudinalMeters meters: CLLocationDistance) -> CLLocationDegrees {
        let offset = meters / Self.metersPerDegree
        return latitude + offset
    }

    func longitudeWithOffset(longitudinalMeters meters: CLLocationDistance) -> CLLocationDegrees {
        let metersPerDegreeLongitude = Self.metersPerDegree * cos(latitude * Double.pi / 180.0)
        let offset = meters / metersPerDegreeLongitude
        return longitude + offset
    }
}


extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description: String {
        let north = latitude > 0
        let west = longitude < 0
        let formattedLatitude = String(format: "%.5f", abs(latitude))
        let formattedLongitude = String(format: "%.5f", abs(longitude))
        return "\(formattedLatitude)º \(north ? "N" : "S"), \(formattedLongitude)º \(west ? "W" : "E")"
    }
}

extension CLLocationCoordinate2D: CustomDebugStringConvertible {
    public var debugDescription: String {
        let formattedLatitude = String(format: "%.5f", latitude)
        let formattedLongitude = String(format: "%.5f", longitude)
        return "\(formattedLatitude), \(formattedLongitude)"
    }
}
