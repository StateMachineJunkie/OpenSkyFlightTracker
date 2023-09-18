//
//  ViewModel.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/30/23.
//

import CoreLocation
import MapKit
import OpenSkyAPI
import os.log

class ViewModel: ObservableObject {
    private var locationProvider: CLLocationProvider
    private let logger = Logger.logger(for: CLLocationProvider.self)

    enum State {
        case idle, loadingData, error(Error)
    }

    @Published var stateVectors = OpenSkyService.StateVectors(time: 0, states: [])
    @Published var state: State = .idle
    @Published var locationInfo = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                                     latitudinalMeters: 200_000,
                                                     longitudinalMeters: 200_000)

    var isLoadingData: Bool {
        if case .loadingData = state {
            return true
        }
        return false
    }

    init(with locationProvider: CLLocationProvider) {
        self.locationProvider = locationProvider
    }

    @MainActor
    func loadData(for area: OpenSkyService.WGS84Area? = nil) {
        switch state {
        case .loadingData:
            logger.debug("Duplicate loadData request!")
            return
        default:
            break
        }

        state = .loadingData
        let service = GetAllStateVectors()
        if let area {
            service.area = area
        }
        Task { [locationProvider] in
            let location = try await locationProvider.currentLocation()
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 200_000, longitudinalMeters: 200_000)
            service.area = OpenSkyService.WGS84Area(lamin: Float(region.center.latitude - region.span.latitudeDelta / 2),
                                                    lomin: Float(region.center.longitude - region.span.longitudeDelta / 2),
                                                    lamax: Float(region.center.latitude + region.span.latitudeDelta / 2),
                                                    lomax: Float(region.center.longitude + region.span.longitudeDelta / 2))
            do {
                let stateVectors = try await service.invoke()
                await MainActor.run {
                    logger.debug("Updated region: \(String(describing: region))")
                    self.locationInfo = region
                    logger.debug("Updated state vectors: \(String(describing: stateVectors))")
                    self.stateVectors = stateVectors
                    state = .idle
                }
            } catch {
                logger.error("Failed to fetch state vectors from OpenSky Network. \(error.localizedDescription)")
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
}

extension OpenSkyService.StateVectors: CustomStringConvertible {
    public var description: String {
        if states.count > 0 {
            var result = "\(states.count) vectors as of \(Date(timeIntervalSince1970: TimeInterval(time)))\n"

            for state in states {
                result.append("\(state.description)\n")
            }

            return result
        } else {
            return "No data"
        }
    }
}

extension OpenSkyService.StateVector: CustomStringConvertible {
    public var description: String {
        var result = "\(icao24)"

        if let latitude, let longitude {
            result.append(" @ \(CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude)))")
        }

        if let altitude {
            result.append(" A: \(altitude)m")
        }

        if let velocity {
            result.append(" V: \(velocity)m/sec")
        }

        return result
    }
}
