//
//  MockOpenSkyAPI.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/30/23.
//

import Foundation

struct MockOpenSkyAPI: OpenSkyServices {
    static func getAllStateVectors(for transponders: [OpenSkyAPI.ICAO24]? = nil,
                                   at time: Int? = nil,
                                   in area: OpenSkyAPI.WGS84Area? = nil,
                                   with authentication: OpenSkyAPI.Authentication? = nil,
                                   includingCategory isIncludingCategory: Bool = false) async throws -> OpenSkyAPI.StateVectors {
        throw "Not yet implemented!"
    }

    static func getOwnStateVectors(for transponders: [OpenSkyAPI.ICAO24]? = nil,
                                   at time: Int? = nil,
                                   filteredFor serials: [String]? = nil,
                                   with authentication: OpenSkyAPI.Authentication) async throws -> OpenSkyAPI.StateVectors {
        throw "Not yet implemented!"
    }

    static func getAllFlights(in timeInterval: Range<Int>? = nil) async throws -> [OpenSkyAPI.Flight] {
        throw "Not yet implemented!"
    }

    static func getFlights(for aircraft: [OpenSkyAPI.ICAO24], in timeInterval: Range<Int>? = nil) async throws -> [OpenSkyAPI.Flight] {
        throw "Not yet implemented!"
    }

    static func getArrivals(at airport: String, in timeInterval: Range<Int>?) async throws -> [OpenSkyAPI.Flight] {
        throw "Not yet implemented!"
    }

    static func getDepartures(from airport: String, in timeInterval: Range<Int>?) async throws -> [OpenSkyAPI.Flight] {
        throw "Not yet implemented!"
    }

    static func getTrack(for transponder: OpenSkyAPI.ICAO24, at time: Int = 0) async throws -> OpenSkyAPI.Track {
        throw "No yet implemented!"
    }
}
