//
//  Flight.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/28/23.
//

import Foundation

extension OpenSkyService {

    struct Flight: Equatable, Hashable {
        let icao24: ICAO24                  // Transponder address
        let firstSeen: Int                  // Time this flight was first seen in seconds since (Unix) epoch?
        let departureAirport: String?
        let lastSeen: Int                   // Time this flight was last seen in seconds since (Unix) epoch?
        let arrivalAirport: String?
        let callsign: String?
        let departureAirportHDistance: Int? // Horizontal distance (units?) from departure airport
        let departureAirportVDistance: Int? // Vertical distance (units?) from departure airport
        let arrivalAirportHDistance: Int?   // Horizontal distance (units?) from arrival airport
        let arrivalAirportVDistance: Int?   // Vertical distance (units?; direct vector or altitude?) from arrival airport
        let departureAirportCandidatesCount: Int
        let arrivalAirportCandidatesCount: Int
    }
}

extension OpenSkyService.Flight: Codable {
    private enum CodingKeys: String, CodingKey {
        case icao24
        case firstSeen
        case departureAirport = "estDepartureAirport"
        case lastSeen
        case arrivalAirport = "estArrivalAirport"
        case callsign
        case departureAirportHDistance = "estDepartureAirportHorizDistance"
        case departureAirportVDistance = "estDepartureAirportVertDistance"
        case arrivalAirportHDistance = "estArrivalAirportHorizDistance"
        case arrivalAirportVDistance = "estArrivalAirportVertDistance"
        case departureAirportCandidatesCount
        case arrivalAirportCandidatesCount
    }
}
