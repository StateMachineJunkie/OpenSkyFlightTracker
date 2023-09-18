// 
// AircraftView.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/26/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import SwiftUI

struct AircraftView: View {
    var angle: Double
    var isSelected: Bool

    var body: some View {
        if isSelected {
            Image(systemName: "airplane")
                .rotationEffect(Angle(degrees: angle - 90))
                .foregroundColor(.red)
        } else {
            Image(systemName: "airplane")
                .rotationEffect(Angle(degrees: angle - 90))
        }
    }
}

#Preview {
    AircraftView(angle: 90, isSelected: true)
        .scaleEffect(CGSize(width: 3.0, height: 3.0))
}

#Preview {
    AircraftView(angle: 90, isSelected: false)
        .scaleEffect(CGSize(width: 3.0, height: 3.0))
}
