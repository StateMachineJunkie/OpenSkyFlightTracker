// 
// ActivityIndicatorView.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/18/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var body: some View {
        ProgressView("OpenSky Network Update")
            .progressViewStyle(.circular)
            .foregroundColor(.white)
            .tint(.white)
            .padding()
            .background(Color(white: 0.0, opacity: 0.5))
            .cornerRadius(10.0)
    }
}

#Preview {
    ActivityIndicatorView()
}
