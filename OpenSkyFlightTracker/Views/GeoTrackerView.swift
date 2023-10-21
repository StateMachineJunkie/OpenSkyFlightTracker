// 
// GeoTrackerView.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 10/4/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import OpenSkyAPI
import SwiftUI

struct GeoTrackerView: View {
    @State var viewModel: GeoTrackingVM

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let vector = OpenSkyService.StateVector.init(icao24: "7504fc",
                                                 callsign: "AMX6311",
                                                 originCountry: "Malaysia",
                                                 timePosition: 1693234261,
                                                 lastContact:1693234261,
                                                 longitude: 101.1146,
                                                 latitude: 4.0066,
                                                 altitude: 9357.36,
                                                 isOnGround: false,
                                                 velocity: 221.56,
                                                 trueTrack: 153.97,
                                                 verticalRate: -4.88,
                                                 sensors: nil,
                                                 geoAltitude: 10020.3,
                                                 squawk: nil,
                                                 isSPI: false,
                                                 positionSource: .adsb,
                                                 category: nil)
    let vm = GeoTrackingVM()
    Task {
        try await vm.initialize()
        vm.track(item: vector)
    }
    return GeoTrackerView(viewModel: vm)
}
