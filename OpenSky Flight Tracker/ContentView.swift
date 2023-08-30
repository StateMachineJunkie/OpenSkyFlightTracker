//
//  ContentView.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    //@ObservedObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
