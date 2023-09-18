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
        ZStack {
            Rectangle()
                .foregroundColor(Color(white: 0.0, opacity: 0.2))
            ProgressView("OpenSky Network Update")
                .progressViewStyle(.circular)
                .foregroundColor(.accentColor)
                .tint(.accentColor)
        }
    }
}

#Preview {
    ActivityIndicatorView()
}
