//
//  StateVector.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/28/23.
//

import Foundation

extension OpenSkyService {

    struct StateVector: Hashable {
        enum PositionSource: Int, Codable {
            case adsb       = 0     // ADS-B
            case asterix    = 1     // ASTERIX
            case mlat       = 2     // MLAT
            case flarm      = 3     // FLARM
        }

        enum AircraftCategory: Int, Codable {
            case noInformation      = 0     // No information at all
            case noADSBCategoryInfo = 1     // No ADS-B emitter category info
            case light              = 2     // Is less than 15500 lbs
            case small              = 3     // 15500 to 75000 lbs
            case large              = 4     // 75000 to 300000 lbs
            case highVortexLarge    = 5     // For example: B-757
            case heavy              = 6     // Is greater than 300000 lbs
            case highPerformance    = 7     // Has greater than 5g acceleration and 400 knots
            case rotorcraft         = 8
            case glider             = 9     // or sailplane
            case lighterThanAir     = 10    // For example: balloon
            case parachutist        = 11    // or skydiver
            case ultralight         = 12    // or hang-glider; paraglider
            case reserved           = 13
            case unmanned           = 14    // Unmanned arial vehicle
            case space              = 15    // Space or trans-atmospheric vehicle
            case emergencyVehicle   = 16    // Emergency surface vehicle
            case serviceVehicle     = 17    // Service surface vehicle
            case pointObstacle      = 18    // Point Obstacle (includes tethered balloons)
            case clusterObstacle    = 19    // Cluster Obstacle
            case lineObstacle       = 20    // Line Obstacle
        }

        let icao24: String          // Transponder address in hexadecimal string representation
        let callsign: String?       // Callsign of the vehicle (8 characters); null if no callsign received
        let originCountry: String   // Country name inferred from the ICAO
        let timePosition: UInt?     // Unix timestamp (seconds) for the last position update
        let lastContact: UInt       // Unix timestamp (seconds) for the last update in general
        let longitude: Float?       // WGS-84 longitude in decimal degrees
        let latitude: Float?        // WGS-84 latitude in decimal degrees
        let altitude: Float?        // Barometric altitude in meters
        let isOnGround: Bool        // Indicates if the position was retrieved from a surface position report
        let velocity: Float?        // Velocity over ground in meters/second
        let trueTrack: Float?       // Track in decimal degrees clockwise from north (north = 0º)
        let verticalRate: Float?    // Vertical rate in meters/second. A positive/negative indicates climb/descend
        let sensors: [Int]?         // IDSs of the receivers which contributed to this state vector
        let geoAltitude: Float?     // Geometric altitude in meters.
        let squawk: String?         // The transponder code
        let isSPI: Bool             // Whether flight status indicates Special Purpose Indicator
        let positionSource: PositionSource
        let category: AircraftCategory?

        init(icao24: String,
             callsign: String? = nil,
             originCountry: String,
             timePosition: UInt? = nil,
             lastContact: UInt,
             longitude: Float? = nil,
             latitude: Float? = nil,
             altitude: Float? = nil,
             isOnGround: Bool = false,
             velocity: Float? = nil,
             trueTrack: Float? = nil,
             verticalRate: Float? = nil,
             sensors: [Int]? = nil,
             geoAltitude: Float? = nil,
             squawk: String? = nil,
             isSPI: Bool = false,
             positionSource: PositionSource,
             category: AircraftCategory? = nil) {
            self.icao24 = icao24
            self.callsign = callsign
            self.originCountry = originCountry
            self.timePosition = timePosition
            self.lastContact = lastContact
            self.longitude = longitude
            self.latitude = latitude
            self.altitude = altitude
            self.isOnGround = isOnGround
            self.velocity = velocity
            self.trueTrack = trueTrack
            self.verticalRate = verticalRate
            self.sensors = sensors
            self.geoAltitude = geoAltitude
            self.squawk = squawk
            self.isSPI = isSPI
            self.positionSource = positionSource
            self.category = category
        }
    }
}

extension OpenSkyService.StateVector: Decodable {
    private enum CodingKeys: String, CodingKey {
        case icao24
        case callsign
        case originCountry = "origin_country"
        case timePosition = "time_position"
        case lastContact = "last_contact"
        case longitude
        case latitude
        case altitude = "baro_altitude"
        case isOnGround = "on_ground"
        case velocity
        case trueTrack = "true_track"
        case verticalRate = "vertical_rate"
        case sensors
        case geoAltitude = "geo_altitude"
        case squawk
        case isSPI = "spi"
        case positionSource = "position_source"
        case category
    }

    init(from decoder: Decoder) throws {
        // Use and unkeyed container to decode the state-vector array
        var container   = try decoder.unkeyedContainer()
        icao24          = try container.decode(String.self)
        callsign        = try container.decodeIfPresent(String.self)
        originCountry   = try container.decode(String.self)
        timePosition    = try container.decodeIfPresent(UInt.self)
        lastContact     = try container.decode(UInt.self)
        longitude       = try container.decodeIfPresent(Float.self)
        latitude        = try container.decodeIfPresent(Float.self)
        altitude        = try container.decodeIfPresent(Float.self)
        isOnGround      = try container.decode(Bool.self)
        velocity        = try container.decodeIfPresent(Float.self)
        trueTrack       = try container.decodeIfPresent(Float.self)
        verticalRate    = try container.decodeIfPresent(Float.self)
        sensors         = try container.decodeIfPresent([Int].self)
        geoAltitude     = try container.decodeIfPresent(Float.self)
        squawk          = try container.decodeIfPresent(String.self)
        isSPI           = try container.decode(Bool.self)
        positionSource  = try container.decode(PositionSource.self)
        category        = try container.decodeIfPresent(AircraftCategory.self)
    }
}

extension OpenSkyService {
    struct StateVectors: Decodable, Equatable, Hashable {
        let time: UInt  // The time that the state vectors in this response are associated with. Interval is [time-1, time].
        let states: [StateVector]
    }
}
