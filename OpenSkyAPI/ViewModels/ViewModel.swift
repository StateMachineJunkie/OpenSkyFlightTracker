//
//  ViewModel.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/30/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var stateVectors = OpenSkyAPI.StateVectors(time: 0, states: [])
    @Published var isLoadingData: Bool = false

    @MainActor
    func loadData() {
        guard isLoadingData == false else { return }
        isLoadingData = true
        Task {
            let stateVectors = try await OpenSkyAPI.getAllStateVectors()
            await MainActor.run {
                self.stateVectors = stateVectors
                isLoadingData = false
            }
        }
    }
}
