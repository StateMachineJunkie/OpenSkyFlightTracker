//
//  ContentView.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoadingData {
                ActivityIndicatorView()
            } else {
                HelloWorldView()
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

struct HelloWorldView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
