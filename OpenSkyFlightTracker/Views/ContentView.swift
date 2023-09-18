//
//  ContentView.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel: ViewModel

    var body: some View {
        ZStack {
            MapView(viewModel: viewModel)

            if viewModel.isLoadingData {
                ActivityIndicatorView()
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    ContentView(viewModel: ViewModel(with: CLLocationProvider()))
}
