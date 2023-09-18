// 
// CLLocationProvider.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/15/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import CoreLocation
import os.log

enum CLLocationProviderError: Error {
    case locationQueryAlreadyInProgress
    case notAuthorized
    case providerError(originalError: Error?)
}

class CLLocationProvider: NSObject {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = kCLDistanceFilterNone
        return lm
    }()

    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var authorizationContinuation: CheckedContinuation<Void, Never>?
    private let logger = Logger.logger(for: CLLocationProvider.self)

    @MainActor
    func currentLocation() async throws -> CLLocationCoordinate2D {
        logger.debug("Fetch current location")
        do {
            try await authorizeLocationQueries()
            let location = try await withCheckedThrowingContinuation { continuation in
                locationContinuation = continuation
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
            logger.debug("Returned current location as \(location)")
            return location
        } catch {
            logger.fault("Failed to fetch current location with error: \(error.localizedDescription)")
            throw error
        }
    }

    private func authorizeLocationQueries() async throws {

        func requestAuthorization() async {
            await withCheckedContinuation { continuation in
                authorizationContinuation = continuation
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            }
        }

        if locationManager.authorizationStatus == .notDetermined {
            logger.debug("Location authorization not determined; getting authorization")
            await requestAuthorization()
        }

        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            logger.error("Location authorization denied or restricted by user.")
            throw CLLocationProviderError.notAuthorized
        case .notDetermined:
            logger.fault("Failed to determine location authorization level.")
            throw CLLocationProviderError.notAuthorized
        @unknown default:
            logger.fault("Unexpected fault while attempting to obtain location authorization!")
            throw CLLocationProviderError.providerError(originalError: nil)
        }
    }
}

extension CLLocationProvider: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = locationManager.authorizationStatus   // TODO: Not used, remove!

        // If this delegate invocation is the result of an authorization request, continue the request.
        if let continuation = authorizationContinuation {
            locationManager.delegate = nil
            authorizationContinuation = nil
            continuation.resume()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastCLLocation = locations.last, let continuation = locationContinuation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            locationContinuation = nil
            let location = CLLocationCoordinate2D(latitude: lastCLLocation.coordinate.latitude,
                                                  longitude: lastCLLocation.coordinate.longitude)
            continuation.resume(returning: location)
        }
    }
}
