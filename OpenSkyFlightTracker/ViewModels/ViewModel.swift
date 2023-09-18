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

@Observable class ViewModel {
    private var locationProvider: CLLocationProvider
    private let logger = Logger.logger(for: CLLocationProvider.self)

    enum State {
        case idle, loadingData, error(Error)
    }

    enum Filter: Int, CaseIterable {
        case all, onGround, airborne
    }

    private(set) var filteredStateVectors = OpenSkyService.StateVectors.empty
    private(set) var locationInfo = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                                       latitudinalMeters: 200_000,
                                                       longitudinalMeters: 200_000)
    private(set) var selectedStateVector: OpenSkyService.StateVector?
    private(set) var selectedTrack: OpenSkyService.Track?
    private(set) var state: State = .idle {
        didSet {
            switch (state, oldValue) {
            case (.idle, .idle), (.loadingData, .loadingData), (.error, .error):
                return
            case (.loadingData, _):
                resetSelectionState()
            default:
                break
            }
        }
    }
    private(set) var stateVectors: OpenSkyService.StateVectors = .empty

    var filter: Filter = .all {
        didSet {
            guard filter != oldValue else { return }
            applyFilter()
        }
    }

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
            logger.debug("Load operation already in progress!")
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
                    applyFilter()
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

    @MainActor
    func loadTrack(for aircraft: OpenSkyService.ICAO24) {
        switch state {
        case .loadingData:
            logger.debug("Load operation already in progress!")
            return
        default:
            break
        }

        state = .loadingData
        Task {
            do {
                let service = try GetTracks(for: aircraft)
                let track = try await service.invoke()
                await MainActor.run {
                    logger.debug("Track for \(aircraft.description): \(String(describing: track))")
                    self.selectedTrack = track
                    state = .idle
                }
            } catch {
                logger.error("Failed to fetch track for \(aircraft.description) from OpenSky Network. \(error.localizedDescription)")
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }

    func selectStateVector(with transponder: String?) {
        if let transponder {
            // Filter duplicates
            guard selectedStateVector == nil || transponder != selectedStateVector!.icao24 else { return }

            // Continue with selection of new state-vector
            let stateVector = filteredStateVectors.states.filter({ $0.icao24 == transponder }).first
            logger.debug("Found \(String(describing: stateVector))")
            self.selectedStateVector = stateVector
        } else {
            if selectedStateVector != nil {
                selectedStateVector = nil
            }
        }

        if selectedTrack != nil {
            selectedTrack = nil
        }
    }

    private func applyFilter() {
        if stateVectors.isEmpty && !filteredStateVectors.isEmpty {
            filteredStateVectors = .empty
            return
        }

        switch filter {
        case .airborne:
            filteredStateVectors = OpenSkyService.StateVectors(time: stateVectors.time, states: stateVectors.states.filter { $0.isOnGround == false })
        case .all:
            filteredStateVectors = stateVectors
        case .onGround:
            filteredStateVectors = OpenSkyService.StateVectors(time: stateVectors.time, states: stateVectors.states.filter { $0.isOnGround })
        }
    }

    private func resetSelectionState() {
        selectedTrack = nil
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

        if let trueTrack {
            result.append(" T: \(UInt(round(trueTrack)))º")
        }

        return result
    }
}
