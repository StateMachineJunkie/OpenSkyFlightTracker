//
//  ViewModel.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/30/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var stateVectors = OpenSkyService.StateVectors(time: 0, states: [])
    @Published var isLoadingData: Bool = false

    @MainActor
    func loadData() {
        #if false
        guard isLoadingData == false else { return }
        isLoadingData = true
        let service = GetAllStateVectors()
        Task {
            let stateVectors = try await service.invoke()
            await MainActor.run {
                self.stateVectors = stateVectors
                isLoadingData = false
            }
        }
        #endif
    }
}
