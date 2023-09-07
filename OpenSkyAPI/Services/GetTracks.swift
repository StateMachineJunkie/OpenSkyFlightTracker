//
//  GetTracks.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation
import os.log

// Get the trajectory for a given aircraft at a given time.
//
// The trajectory is a list of `Waypoint` values containing position, barometric altitude, true track and an on-
// ground flag.
//
// In contrast state vectors, trajectories do not contain all information we have about the flight, but rather show
// the aircraft's general movement pattern. For this reason, waypoints are selected among available state vectors
// given the following set of rules:
//
// * The first point is set immediately after the aircraft's expected departure, or after the network received the
// first position report when the aircraft entered its reception range.
// * The last point is set right before the aircraft's expected arrival, or the aircraft left the networks reception
// range.
// * There is a waypoint at least every 15 minutes when the aircraft is in-flight.
// * A waypoint is added if the aircraft changes its track more than 2.5º
// * A waypoint is added if the aircraft changes altitude by more than 100 meters (~300 feet).
// * A waypoint is added if the on-ground state changes.
//
// - Parameters:
//   - transponder: An aircraft transponder. This is a unique ICAO24 value.
//   - time: Time in seconds since (Unix) epoch. It can be any time between the *start* and *end* of a known flight.
//           If **time = 0** (the default value), then get the live track if there is any flight ongoing for the given
//           aircraft.
// - Returns: A `Track` value, if available.
// - Note: The tracks endpoint is purely **experimental** and can be out-of-order at any time. You can use the
//         flights endpoint for historical data.
class GetTracks: OpenSkyService {

    public var authentication: OpenSkyService.Authentication?
    private var time: UInt
	private var transponder: OpenSkyService.ICAO24

    private let logger = Logger.logger(for: GetTracks.self)
    
    init(for transponder: OpenSkyService.ICAO24, at time: UInt = 0) throws {
        self.transponder = transponder
        self.time = time
    }

    func invoke() async throws -> OpenSkyService.Track {
        let params: [String : Any] = [
            "icao24" : transponder.value,
            "time" : String(time)
        ]

        let queryItems: [URLQueryItem] = params.queryItems!
        let url = URL(string: "tracks/all", relativeTo: OpenSkyService.apiBaseURL)!
        let request: URLRequest

        if let authentication {
            request = URLRequest(url: url.appending(queryItems: queryItems), authentication: authentication)
        } else {
            request = URLRequest(url: url.appending(queryItems: queryItems))
        }

        do {
            return try await invoke(with: request)
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
}
