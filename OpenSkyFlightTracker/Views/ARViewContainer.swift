// 
// ARViewContainer.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 10/8/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import OpenSkyAPI
import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {

    @State var stateVectors: OpenSkyService.StateVectors

    func makeUIView(context: Context) -> ARView {
        return ARView(frame: .zero)
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        updateCounter(uiView: uiView)
    }

    private func updateCounter(uiView: ARView) {
        uiView.scene.anchors.removeAll()

        let anchor = AnchorEntity()
        let text = MeshResource.generateText("\(stateVectors.states.count) vectors passed in.",
                                             extrusionDepth: 0.08,
                                             font: .systemFont(ofSize: 0.5, weight: .bold))
        let shader = SimpleMaterial(color: .white, roughness: 4, isMetallic: true)
        let textEntity = ModelEntity(mesh: text, materials: [shader])

        textEntity.position.z -= 1.5
        textEntity.setParent(anchor)
        uiView.scene.addAnchor(anchor)
    }
}

#Preview {
    let stateVector = OpenSkyService.StateVector(icao24: "abc123  ",
                                                 originCountry: "United States",
                                                 lastContact: UInt(Date.now.timeIntervalSince1970),
                                                 longitude: 110.91509,
                                                 latitude: 32.47765,
                                                 altitude: 0.0,
                                                 positionSource: .adsb)
    let previewStateVectors = OpenSkyService.StateVectors(time: UInt(Date.now.timeIntervalSince1970), states: [stateVector])
    return ARViewContainer(stateVectors: previewStateVectors)
}
