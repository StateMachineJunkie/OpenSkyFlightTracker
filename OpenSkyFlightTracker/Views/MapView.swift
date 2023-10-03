// 
// MapView.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 9/15/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import MapKit
import OpenSkyAPI
import os.log
import SwiftUI

struct MapView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedAircraft: String?
    @State private var visibleRegion: MKCoordinateRegion?
    @State var viewModel: ViewModel

    private let logger = Logger.logger(for: MapView.self)

    var body: some View {
        Map(position: $position, selection: $selectedAircraft) {
            ForEach(viewModel.filteredStateVectors.states, id: \.icao24) { aircraft in
                Annotation(aircraft.callsign ?? aircraft.icao24, coordinate: aircraft.coordinate, anchor: .center) {
                    AircraftView(angle: Double(aircraft.trueTrack ?? 00), isSelected: aircraft.icao24 == selectedAircraft)
                }
            }
            if let track = viewModel.selectedTrack {
                MapPolyline(coordinates: track.path.compactMap({ waypoint in
                    guard
                        let latitude = waypoint.latitude,
                        let longitude = waypoint.longitude else {
                        logger.debug("Missing waypoint data: \(String(describing: waypoint))")
                        return nil
                    }
                    let coordinate = CLLocationCoordinate2DMake(Double(latitude), Double(longitude))
                    logger.debug("Track: \(String(describing: coordinate))")
                    return coordinate
                }), contourStyle: .straight).stroke(.blue, lineWidth: 5.0)

            }
        }
        .onChange(of: selectedAircraft, { oldValue, newValue in
            logger.debug("oldValue = \(String(describing: oldValue))\nnewValue = \(String(describing: newValue))")
            viewModel.selectStateVector(with: newValue)
        })
        .mapStyle(.standard)
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .mapControlVisibility(.visible)
        .safeAreaInset(edge: .bottom) {
            VStack {
                if let stateVector = viewModel.selectedStateVector {
                    AircraftInfoView(aircraft: stateVector)
                        .padding(.bottom)
                }
                HStack {
                    Spacer()
                    if let stateVector = viewModel.selectedStateVector {
                        Button {
                            viewModel.loadTrack(for: OpenSkyService.ICAO24(icao24String: stateVector.icao24)!)
                        } label: {
                            Text("Track")
                        }
                    } else {
                        VStack {
                            Picker("Filter Options", selection: $viewModel.filter) {
                                Text("All").tag(ViewModel.Filter.all)
                                Text("On Ground").tag(ViewModel.Filter.onGround)
                                Text("Airborne").tag(ViewModel.Filter.airborne)
                            }
                            .pickerStyle(.segmented)
                            Button {
                                viewModel.loadData()
                            } label: {
                                Text("Refresh")
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.top)
            .background(.thinMaterial)
        }
    }
}

#Preview {
    MapView(viewModel: ViewModel(with: CLLocationProvider()))
}
