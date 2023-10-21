// 
// GeoTrackingVM.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 10/4/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import ARKit
import os.log
import RealityKit

class GeoTrackingVM: NSObject {
    private let config = ARGeoTrackingConfiguration()
    private let logger = Logger.logger(for: GeoTrackingVM.self)

    private(set) var arView: ARView?

    private(set) var geoTrackedItems: [GeoTrackable] = []

    private(set) var geoTrackingStatus: ARGeoTrackingStatus?

    /// Check for device support and user permission. If the device is capable and the user is willing, Create required
    /// resources and start a new geo-tracking session.
    @discardableResult func initialize() async throws -> Bool {
        guard arView == nil else { throw OSFTError.arSessionAlreadyInitialized }
        
        // Check for device support.
        guard ARGeoTrackingConfiguration.isSupported else {
            logger.fault("No device support for geo-tracking. Unable to continue.")
            throw OSFTError.geoTrackingUnavailable
        }

        let isAvailable: Bool = try await withCheckedThrowingContinuation { continuation in
            // Check current location is supported for geo-tracking.
            ARGeoTrackingConfiguration.checkAvailability { isAvailable, error in
                if let error {
                    continuation.resume(throwing: error)
                }

                Task {
                    await MainActor.run {
                        // Run ARSession
                        let arView = ARView()
                        arView.session.run(ARGeoTrackingConfiguration())
                        self.arView = arView
                        continuation.resume(returning: isAvailable)
                    }
                }
            }
        }

        return isAvailable
    }

    func track(item: GeoTrackable) {
        addGeoTrackableItemToView(item)
        geoTrackedItems.append(item)
    }

    func track(contentsOf items: [GeoTrackable]) {
        for item in items {
            addGeoTrackableItemToView(item)
        }
        geoTrackedItems.append(contentsOf: items)
    }

    func removeAllGeoTrackableItems() {
        geoTrackedItems.removeAll()
    }

    private func addGeoTrackableItemToView(_ item: GeoTrackable) {
        /*
        let anchor = item.geoAnchor
        arView!.session.add(anchor: anchor)
        let geoAnchorEntity = AnchorEntity(anchor: anchor as ARAnchor)
        arView!.scene.addAnchor(geoAnchorEntity)
         */
    }
}
