//
//  GetFlights.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation
import os.log

// Get flights for a given set of aircraft within a given time interval.
//
// - Parameters:
//   - transponders: Array of aircraft transponders identifiers. These are unique ICAO24 values.
//   - timeInterval: `ClosedRange` [begin, end] in seconds from (Unix) epoch.
// - Returns: If successful an array of `Flight` values is returned. This array may be empty if there are none
//            matching the given parameters.
// - Note: The transponder array must contain at least one value in order for the service to complete successfully.
// - Note: The interval range must be less than or equal to thirty days and must be a non-zero value.
class GetFlights: OpenSkyService {

    public var authentication: OpenSkyService.Authentication?
    private var timeInterval: ClosedRange<UInt>
	private var transponders: [OpenSkyService.ICAO24]

    private let logger = Logger.logger(for: GetFlights.self)

    init(for transponders: [OpenSkyService.ICAO24], in timeInterval: ClosedRange<UInt>) throws {
        guard transponders.count > 0 else {
            throw OpenSkyService.Error.invalidTransponderParameter
        }

        self.transponders = transponders
        self.timeInterval = timeInterval
        super.init()

        try validateOpenSkyTimeInterval(timeInterval)
    }

    func invoke() async throws -> [OpenSkyService.Flight] {
        var queryItems: [URLQueryItem] = transponders.queryItems(withKey: "icao24")
        queryItems.append(URLQueryItem(name: "begin", value: String(timeInterval.lowerBound)))
        queryItems.append(URLQueryItem(name: "end", value: String(timeInterval.upperBound)))

        let url = URL(string: "flights/aircraft", relativeTo: OpenSkyService.apiBaseURL)!

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
