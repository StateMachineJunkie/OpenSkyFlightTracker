//
//  OpenSkyAPI.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/26/23.
//

import Foundation

extension String: Error {}  // Remove before shipping

//enum OpenSkyError: Error {
//    case
//}


struct OpenSkyAPI {
    /// Some OpenSky API calls require authentication which consists of a simple username and password.
    struct Authentication {
        let username: String
        let password: String
    }

    /// Bounds for state-vector search.
    struct WGS84Area {
        let lamin: Float    // Minimum latitude
        let lomin: Float    // Minimum longitude
        let lamax: Float    // Maximum latitude
        let lomax: Float    // Maximum longitude
    }

    /// Get state-vectors for aircraft in the OpenSky network.
    ///
    /// - Parameters:
    ///   - transponders: An array containing one or more ICAO24 transponder addresses in lower-cased hexadecimal string
    ///                   representation.
    ///   - time: Time in seconds since (Unix) epoch. This time coordinate represents the time stamp to retrieve states
    ///           for. If this parameter is not provided then the current time will be used in its place.
    ///   - area: If this parameter is included, then the query will only return results contained within the defined
    ///           bounding box of the given set of WGS84 coordinates.
    ///   - includingCategory: Boolean indicating whether or not the aircraft category should be included with each
    ///                        state-vector returned from this invocation.
    ///   - authentication: While authentication is not required to invoke this API call, if it is not included the
    ///                     results will be limited. See `Limitations` in the Original OpenSky API documentation.
    /// - Returns: A `StateVectors` value, which can be empty if no results were found to match the provided parameters.
    static func getAllStateVectors(for transponders: [ICAO24]? = nil,
                                   at time: Int? = nil,
                                   in area: WGS84Area? = nil,
                                   includingCategory isIncludingCategory: Bool = false,
                                   with authentication: Authentication? = nil) async throws -> StateVectors {
        var params: [String : Any] = [:]

        if let transponders {
            params["icao24"] = transponders.map { $0.value }
        }
        if let time {
            params["time"] = time
        }
        if let area {
            params["lamin"] = area.lamin
            params["lamax"] = area.lamax
            params["lomin"] = area.lomin
            params["lomax"] = area.lomax
        }
        if isIncludingCategory {
            params["extended"] = 1
        }
        let openSkyURL = URL(string: "https://opensky-network.org/api/states/all")!
        let request = URLRequest(url: openSkyURL)
        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard (200..<300).contains(statusCode) else { throw "Bad HTTP status: \(statusCode)" }
        do {
            let model = try JSONDecoder().decode(StateVectors.self, from: data)
            return model
        } catch let error {
            print(error)
            throw error
        }
    }

    /// Get state-vectors for your won sensors without any rate limitations.
    ///
    /// - Parameters:
    ///   - transponders: An array containing one or more ICAO24 transponder addresses in lower-cased hexadecimal string
    ///                   representation.
    ///   - time: Time in seconds since (Unix) epoch. This time coordinate represents the time stamp to retrieve states
    ///           for. If this parameter is not provided then the current time will be used in its place.
    ///   - serials: This parameter will filter the states of a subset of your receivers.
    ///   - authentication: Required in order to invoke this API call.
    /// - Returns: A `StateVectors` value, which can be empty if no results were found to match the provided parameters.
    static func getOwnStateVectors(for transponders: [ICAO24]? = nil,
                                   at time: Int? = nil,
                                   filteredFor serials: [String]? = nil,
                                   with authentication: Authentication) async throws -> StateVectors {
        throw "Not yet implemented!"
    }

    /// Get flights for a given time interval.
    ///
    /// - Parameter timeInterval: Range [begin, end] in seconds from (Unix) epoch.
    /// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
    ///            matching the given time interval.
    /// - Note: The interval range must be less than or equal to two hours.
    static func getAllFlights(in timeInterval: Range<Int>? = nil) async throws -> [Flight] {
        throw "Not yet implemented!"
    }

    /// Get flights for a given set of aircraft within a given time interval.
    ///
    /// - Parameters:
    ///   - aircraft: Array of aircraft transponders identifiers. These are unique ICAO 24-bit addresses in lower-cased
    ///               hexadecimal string representation.
    ///   - timeInterval: Range [begin, end] in seconds from (Unix) epoch.
    /// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
    ///            matching the given parameters.
    /// - Note: The interval range must be less than or equal to thirty days.
    static func getFlights(for aircraft: [ICAO24], in timeInterval: Range<Int>? = nil) async throws -> [Flight] {
        throw "Not yet implemented!"
    }

    /// Get arrivals by airport.
    ///
    /// Retrieve flights fora certain airport which arrived within a given time interval [begin, end].
    ///
    /// - Parameters:
    ///   - airport: ICAO identifier for the airport.
    ///   - timeInterval: Range [begin, end] in seconds from (Unix) epoch.
    /// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
    ///            matching the given parameters.
    /// - Note: The interval range must be less than or equal to seven days.
    static func getArrivals(at airport: String, in timeInterval: Range<Int>?) async throws -> [Flight] {
        throw "Not yet implemented!"
    }

    /// Get departures by airport.
    ///
    /// Retrieve flights for a certain airport which departed within a given time interval [begin, end].
    ///
    /// - Parameters:
    ///   - airport: ICAO identifier for the airport.
    ///   - timeInterval: Range [begin, end] in seconds from (Unix) epoch.
    /// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
    ///            matching the given parameters.
    /// - Note: The interval range must be less than or equal to seven days.
    static func getDepartures(from airport: String, in timeInterval: Range<Int>?) async throws -> [Flight] {
        throw "Not yet implemented!"
    }

    /// Get the trajectory for a given aircraft at a given time.
    ///
    /// The trajectory is a list of `Waypoint` values containing position, barometric altitude, true track and an on-
    /// ground flag.
    ///
    /// In contrast state vectors, trajectories do not contain all information we have about the flight, but rather show
    /// the aircraft's general movement pattern. For this reason, waypoints are selected among available state vectors
    /// given the following set of rules:
    ///
    /// * The first point is set immediately after the aircraft's expected departure, or after the network received the
    /// first position report when the aircraft entered its reception range.
    /// * The last point is set right before the aircraft's expected arrival, or the aircraft left the networks reception
    /// range.
    /// * There is a waypoint at least every 15 minutes when the aircraft is in-flight.
    /// * A waypoint is added if the aircraft changes its track more than 2.5º
    /// * A waypoint is added if the aircraft changes altitude by more than 100 meters (~300 feet).
    /// * A waypoint is added if the on-ground state changes.
    ///
    /// - Parameters:
    ///   - transponder: An aircraft transponder. This is a unique ICAO 24-bit address in lower-cased hexadecimal string
    ///                  representation.
    ///   - time: Time in seconds since (Unix) epoch. It can be any time between the *start* and *end* of a known flight.
    ///           If **time = 0**, get the live track if there is any flight ongoing for the given aircraft.
    /// - Returns: A `Track` value, if available.
    /// - Note: The tracks endpoint is purely **experimental** and can be out-of-order at any time. You can use the
    ///         flights endpoint for historical data.
    static func getTrack(for transponder: ICAO24, at time: Int = 0) async throws -> Track {
        throw "No yet implemented!"
    }
}
