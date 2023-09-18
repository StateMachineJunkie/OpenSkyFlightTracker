// 
// AircraftInfoView.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/18/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import MapKit
import OpenSkyAPI
import SwiftUI

struct AircraftInfoView: View {
    @State var aircraft: OpenSkyService.StateVector

    var body: some View {
        VStack {
            HStack(spacing: 2) {
                column(width: 150, alignment: .trailing, text: "Flight")
                column(alignment: .center, text: ":")
                column(width: 150, alignment: .leading, text: aircraft.displayFlightName)
            }
            HStack(spacing: 2) {
                column(width: 150, alignment: .trailing, text: "Aircraft ID")
                column(alignment: .center, text: ":")
                column(width: 150, alignment: .leading, text: aircraft.displayTransponder)
            }
            HStack(spacing: 2) {
                column(width: 150, alignment: .trailing, text: "Velocity")
                column(alignment: .center, text: ":")
                column(width: 150, alignment: .leading, text: aircraft.displayVelocity)
            }
            HStack(spacing: 2) {
                column(width: 150, alignment: .trailing, text: "Altitude")
                column(alignment: .center, text: ":")
                column(width: 150, alignment: .leading, text: aircraft.displayAltitude)
            }
            HStack(spacing: 2) {
                column(width: 150, alignment: .trailing, text: "Heading")
                column(alignment: .center, text: ":")
                column(width: 150, alignment: .leading, text: aircraft.displayHeading)
            }
        }
    }

    private func column(width: CGFloat, alignment: Alignment, text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .frame(width: width, alignment: alignment)
    }

    private func column(alignment: HorizontalAlignment, text: String) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    AircraftInfoView(aircraft: OpenSkyService.StateVector(icao24: "abcdef",
                                                          callsign: "UA123",
                                                          originCountry: "United States",
                                                          lastContact: 0,
                                                          altitude: 2080.0,
                                                          velocity: 51.0,
                                                          trueTrack: 223.0,
                                                          positionSource: .adsb))
}
