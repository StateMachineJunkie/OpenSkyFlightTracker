// 
// GeoTrackableProtocol.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 10/4/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import ARKit
import CoreLocation

protocol GeoTrackable {
    var name: String { get }
    var coordinate: CLLocationCoordinate2D { get }
}

extension GeoTrackable {
    var geoAnchor: ARGeoAnchor {
        ARGeoAnchor(name: name, coordinate: coordinate)
    }
}
