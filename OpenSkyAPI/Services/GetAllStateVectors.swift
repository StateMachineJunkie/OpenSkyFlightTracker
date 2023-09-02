//
//  GetAllStateVectors.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation
import os.log

// Get state-vectors for aircraft in the OpenSky network.
//
// - Parameters:
//   - transponders: An array containing one or more ICAO24 transponder addresses in lower-cased hexadecimal string
//                   representation.
//   - time: Time in seconds since (Unix) epoch. This time coordinate represents the time stamp to retrieve states
//           for. If this parameter is not provided then the current time will be used in its place.
//   - area: If this parameter is included, then the query will only return results contained within the defined
//           bounding box of the given set of WGS84 coordinates.
//   - authentication: While authentication is not required to invoke this API call, if it is not included the
//                     results will be limited. See `Limitations` in the Original OpenSky API documentation.
//   - isIncludingCategory: Boolean indicating whether or not the aircraft category should be included with each
//                          state-vector returned from this invocation.
// - Returns: A `StateVectors` value, which can be empty if no results were found to match the provided parameters.
class GetAllStateVectors: OpenSkyService {

    public var area: OpenSkyService.WGS84Area?
    public var authentication: OpenSkyService.Authentication?
    public var isIncludingCategory: Bool = false
    public var time: UInt?
    public var transponders: [OpenSkyService.ICAO24]?

    private let logger = Logger.logger(for: GetAllStateVectors.self)

    func invoke() async throws -> OpenSkyService.StateVectors {
        var queryItems: [URLQueryItem] = []

        if let transponders {
            queryItems.append(contentsOf: transponders.queryItems(withKey: "icao24"))
        }

        var params: [String : Any] = [:]

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

        if let paramQueryItems = params.queryItems {
            queryItems.append(contentsOf: paramQueryItems)
        }

        let url = URL(string: "states/all", relativeTo: OpenSkyService.apiBaseURL)!
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
