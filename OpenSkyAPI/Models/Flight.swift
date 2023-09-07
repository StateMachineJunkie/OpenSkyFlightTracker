//
//  Flight.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/28/23.
//

import Foundation

extension OpenSkyService {

    struct Flight: Decodable, Equatable, Hashable {
        let icao24: String                          // Transponder address
        let firstSeen: UInt                         // Time this flight was first seen in seconds since (Unix) epoch?
        let estDepartureAirport: String?
        let lastSeen: UInt                          // Time this flight was last seen in seconds since (Unix) epoch?
        let estArrivalAirport: String?
        let callsign: String?
        let estDepartureAirportHorizDistance: Int?  // Horizontal distance (units?) from departure airport
        let estDepartureAirportVertDistance: Int?   // Vertical distance (units?) from departure airport
        let estArrivalAirportHorizDistance: Int?    // Horizontal distance (units?) from arrival airport
        let estArrivalAirportVertDistance: Int?     // Vertical distance (units?; direct vector or altitude?) from arrival airport
        let departureAirportCandidatesCount: Int
        let arrivalAirportCandidatesCount: Int
    }
}
