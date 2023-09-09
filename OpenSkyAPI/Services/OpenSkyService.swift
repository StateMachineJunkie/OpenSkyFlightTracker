//
//  OpenSkyService.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation

public class OpenSkyService: NSObject {

    public var maxTimeInterval: UInt {
        60 * 60 * 24 * 30 // Default to a maximum interval of 30 days
    }

    public enum Error: Swift.Error {
        case httpInfoResponse(Int)
        case httpRedirect(Int)
        case httpClientError(Int)
        case httpServerError(Int)
        case httpUnexpectedStatus(Int)
        case invalidTimeParameter
        case invalidTransponderParameter
        case httpErrorResponse(ErrorModel)
    }

    /// Some OpenSky API calls require authentication which consists of a simple username and password.
    public struct Authentication: Equatable, Hashable {
        let username: String
        let password: String
    }

    /// Since these appear throughout the API and they have specific characteristics that distinguish them from a
    /// standard `String`, I felt like it would be a good idea to make them their own type so that we can check them.
    /// It should reduce the number of potential errors that would only show-up at runtime.
    public struct ICAO24: Codable, Equatable, Hashable {
        let value: String

        public init?(icao24String: String) {
            guard icao24String.isICAO24 else { return nil }
            self.value = icao24String.lowercased()
        }
    }

    /// Bounds for state-vector search.
    public struct WGS84Area {
        let lamin: Float    // Minimum latitude
        let lomin: Float    // Minimum longitude
        let lamax: Float    // Maximum latitude
        let lomax: Float    // Maximum longitude
    }

    internal static let apiBaseURL: URL = {
        return URL(string: "https://opensky-network.org/api/")!
    }()

    public static var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.ephemeral)
    }()

    internal func validateOpenSkyTimeInterval(_ timeInterval: ClosedRange<UInt>) throws {
        let delta = timeInterval.upperBound - timeInterval.lowerBound
        guard
            delta >= 0,
            delta <= maxTimeInterval else {
            throw Error.invalidTimeParameter
        }
    }

    internal func invoke<T: Decodable>(with request: URLRequest) async throws -> T {
        let (data, response) = try await OpenSkyService.session.data(for: request)
        let httpResponse = response as! HTTPURLResponse
        guard httpResponse.statusCode == 200 else {
            if let errorModel = try? JSONDecoder().decode(OpenSkyService.ErrorModel.self, from: data) {
                // I did not learn about the error payload being returned when the HTTP request fails until I
                // started testing. It is not mentioned in the documentation. In fact, the documentation only
                // mentions empty response bodies on failures. Thus, I added this after the fact.
                throw OpenSkyService.Error.httpErrorResponse(errorModel)
            } else {
                throw httpResponse.statusCode.mappedToError
            }
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension Int {
    var mappedToError: Error {
        switch self {
        case 100..<200:
            return OpenSkyService.Error.httpInfoResponse(self)
        case 300..<400:
            return OpenSkyService.Error.httpRedirect(self)
        case 400..<500:
            return OpenSkyService.Error.httpClientError(self)
        case 500..<600:
            return OpenSkyService.Error.httpServerError(self)
        default:
            return OpenSkyService.Error.httpUnexpectedStatus(self)
        }
    }
}

extension OpenSkyService.ICAO24: LosslessStringConvertible {
    public init?(_ description: String) { self.init(icao24String: description) }
    public var description: String { value }
}

extension URLRequest {
    public init(url: URL, authentication: OpenSkyService.Authentication) {
        self.init(url: url)
        let authString = "\(authentication.username):\(authentication.password)"
        let data = authString.data(using: .utf8)!   // Lossless conversions cannot fail so this is acceptable.
        setValue("Basic \(data.base64EncodedString())", forHTTPHeaderField: "Authorization")
    }
}
