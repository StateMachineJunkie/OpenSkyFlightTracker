//
//  ViewModel.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/30/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var stateVectors = StateVectors(time: 0, states: [])

    func loadData() {
        Task {
            let stateVectors = try await OpenSkyAPI.getAllStateVectors()
            self.stateVectors = stateVectors
        }
    }
}
