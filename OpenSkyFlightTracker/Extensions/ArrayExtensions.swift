// 
// ArrayExtensions.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/27/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import CoreLocation
import Foundation
import OpenSkyAPI

extension Array where Element == OpenSkyService.Waypoint {
    /// Some waypoints have consecutively duplicated lat/lon coordinates. Even though the timestamps are different we
    /// don't want to plot duplicate points on the map. This property returns the original value filtered for duplicate
    /// coordinates.
    var filteredDuplicates: [Element] {
        return self.reduce([]) { partialResult, waypoint in
            if partialResult.isEmpty {
                return [waypoint]
            } else if partialResult.last! == waypoint {
                return partialResult
            } else {
                var result = partialResult
                result.append(waypoint)
                return result
            }
        }
    }

    var filteredDuplicateCoordinates: [Element] {
        return self.reduce([]) { partialResult, waypoint in
            if partialResult.isEmpty {
                return [waypoint]
            } else if partialResult.last!.coordinate == waypoint.coordinate {
                return partialResult
            } else {
                var result = partialResult
                result.append(waypoint)
                return result
            }
        }
    }
}

extension OpenSkyService.Waypoint {
    struct WaypointCoordinate: Equatable {
        let latitude: Float
        let longitude: Float
    }

    var coordinate: WaypointCoordinate? {
        guard
            let latitude = latitude,
            let longitude = longitude else {
            return nil
        }
        return WaypointCoordinate(latitude: latitude, longitude: longitude)
    }
}
