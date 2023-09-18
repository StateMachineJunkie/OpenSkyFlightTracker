// 
// MapView.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/15/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import MapKit
import SwiftUI
import OpenSkyAPI

struct MapView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @State var stateVectors: OpenSkyService.StateVectors

    var body: some View {
        Map(position: $position) {
            ForEach(stateVectors.states, id: \.icao24) { aircraft in
                if let coordinate = aircraft.coordinate {
                    Annotation(aircraft.icao24, coordinate: coordinate, anchor: .center) {
                        Image(systemName: "airplane")
                    }
                }
            }
        }
        .mapStyle(.standard)
        .onChange(of: stateVectors) {
            position = .automatic
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
    }
}

#Preview {
    MapView(stateVectors: ViewModel(with: CLLocationProvider()).stateVectors)
}

extension OpenSkyService.StateVector {
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
    }
}
