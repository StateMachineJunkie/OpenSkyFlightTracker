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
        VStack {
            if viewModel.isLoadingData {
                ActivityIndicatorView()
            } else {
                MapView(stateVectors: viewModel.stateVectors)
            }
        }
        .padding()
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct ActivityIndicatorView: View {
    var body: some View {
        VStack {
            ProgressView("Network activity is happening!")
                .progressViewStyle(.circular)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel(with: CLLocationProvider()))
    }
}
