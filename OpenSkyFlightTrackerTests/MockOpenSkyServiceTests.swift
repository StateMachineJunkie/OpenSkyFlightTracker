//
//  OpenSkyServiceTests.swift
//  OpenSky Flight TrackerTests
//
//  Created by Michael Crawford on 8/30/23.
//

import XCTest
@testable import OpenSkyFlightTracker

final class MockOpenSkyServiceTests: XCTestCase {

    // We just want to execute this code once regardless of the number of tests associated with this class.
    private static var sut: URLSession = {
        // URLProtocol.registerClass(MockURLProtocol.self)
        // Apparently the previous line is not necessary; solution still works without registration.
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let sut = URLSession(configuration: config)
        OpenSkyService.session = sut
        return sut
    }()

    override func setUpWithError() throws {
        print("System under test: \(MockOpenSkyServiceTests.sut)")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getAllStateVectors_with_no_transponders() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            let data = try MockURLProtocol.loadJSONResource(named: "opensky_api_states_all_output")
            return (data, response)
        }

        // Act
        let service = GetAllStateVectors()
        let stateVectors = try await service.invoke()

        // Assert
        XCTAssertEqual(stateVectors.time, 1693234261)
        XCTAssertEqual(stateVectors.states.count, 9810) // Lots of data to play with!

        // Verify matching data for first state-vector.
        let expectedFirstStateVector = OpenSkyService.StateVector(icao24: "a2d2c8",
                                                                  callsign: "N281MC  ",
                                                                  originCountry: "United States",
                                                                  timePosition: 1693234183,
                                                                  lastContact: 1693234183,
                                                                  longitude: -77.3198,
                                                                  latitude: 42.9116,
                                                                  altitude: 190.5,
                                                                  velocity: 0,
                                                                  trueTrack: 0,
                                                                  verticalRate: -0.33,
                                                                  geoAltitude: 220.98,
                                                                  squawk: "6263",
                                                                  positionSource: .adsb)
        assertEqualStateVectors(expectedFirstStateVector, stateVectors.states[0])

        // Verify matching data for last state-vector.
        let expectedLastStateVector = OpenSkyService.StateVector(icao24: "a60bbd",
                                                                 callsign: "DPJ489  ",
                                                                 originCountry: "United States",
                                                                 timePosition: 1693234261,
                                                                 lastContact: 1693234261,
                                                                 longitude: -76.6613,
                                                                 latitude: 39.383,
                                                                 altitude: 8145.78,
                                                                 velocity: 139.58,
                                                                 trueTrack: 248.83,
                                                                 verticalRate: 10.08,
                                                                 geoAltitude: 8549.64,
                                                                 squawk: "3311",
                                                                 positionSource: .adsb)
        assertEqualStateVectors(expectedLastStateVector, stateVectors.states[9809])

        // Verify optional fields with state-vector three.
        let state = stateVectors.states[3]
        XCTAssertNil(state.verticalRate)
        XCTAssertNil(state.geoAltitude)
        XCTAssertNil(state.squawk)
    }

    func test_getAllStateVectors_with_multiple_transponder() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            let data = try MockURLProtocol.loadJSONResource(named: "opensky_api_states_all_output")
            return (data, response)
        }

        // Act
        let service = GetAllStateVectors()
        service.transponders = [OpenSkyService.ICAO24(icao24String: "a798d0")!, OpenSkyService.ICAO24(icao24String: "aa3cbe")!]
        let stateVectors = try await service.invoke()

        // Assert
        let expectedFirstStateVector = OpenSkyService.StateVector(icao24: "a798d0",
                                                                  callsign: "N589RB  ",
                                                                  originCountry: "United States",
                                                                  timePosition: 1693234261,
                                                                  lastContact: 1693234261,
                                                                  longitude: -81.4225,
                                                                  latitude: 28.9196,
                                                                  altitude: 4747.26,
                                                                  velocity: 98.05,
                                                                  trueTrack: 24.82,
                                                                  verticalRate: 0,
                                                                  geoAltitude: 5013.96,
                                                                  positionSource: .adsb)
        assertEqualStateVectors(expectedFirstStateVector, stateVectors.states[4])

        let expectedSecondStateVector = OpenSkyService.StateVector(icao24: "aa3cbe",
                                                                  callsign: "N759PA  ",
                                                                  originCountry: "United States",
                                                                  timePosition: 1693234249,
                                                                  lastContact: 1693234249,
                                                                  longitude: -111.95,
                                                                  latitude: 41.9208,
                                                                  altitude: 2209.8,
                                                                  velocity: 48.97,
                                                                  trueTrack: 350.93,
                                                                  verticalRate: 0,
                                                                  geoAltitude: 2354.58,
                                                                  positionSource: .adsb)
        assertEqualStateVectors(expectedSecondStateVector, stateVectors.states[5])

    }

    func test_getAllStateVectors_with_single_transponder_success() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            let data = try MockURLProtocol.loadJSONResource(named: "opensky_api_states_single_output")
            return (data, response)
        }

        // Act
        let service = GetAllStateVectors()
        service.transponders = [OpenSkyService.ICAO24(icao24String: "7504fc")!]
        let stateVectors = try await service.invoke()

        // Assert
        let expectedStateVector = OpenSkyService.StateVector(icao24: "7504fc",
                                                                  callsign: "AXM6311 ",
                                                                  originCountry: "Malaysia",
                                                                  timePosition: 1693234261,
                                                                  lastContact: 1693234261,
                                                                  longitude: 101.1146,
                                                                  latitude: 4.0066,
                                                                  altitude: 9357.36,
                                                                  velocity: 221.56,
                                                                  trueTrack: 153.97,
                                                                  verticalRate: -4.88,
                                                                  geoAltitude: 10020.3,
                                                                  positionSource: .adsb)
        assertEqualStateVectors(expectedStateVector, stateVectors.states[0])
    }

    func test_getAllTracks() async throws {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            let data = try MockURLProtocol.loadJSONResource(named: "opensky_api_tracks_all_output")
            return (data, response)
        }

        // Act
        let service = try GetTracks(for: OpenSkyService.ICAO24(icao24String: "0ac382")!)
        let track = try await service.invoke()

        // Assert
        XCTAssertEqual(track.icao24, "0ac382")
        XCTAssertEqual(track.callsign, "HK5220  ")
        XCTAssertEqual(track.startTime, 1694114383)
        XCTAssertEqual(track.endTime, 1694115007)
        XCTAssertEqual(track.path.count, 40)
    }

    private func assertEqualStateVectors(_ lhs: OpenSkyService.StateVector,
                                         _ rhs: OpenSkyService.StateVector,
                                         file: StaticString = #filePath,
                                         line: UInt = #line) {
        XCTAssertEqual(lhs.icao24, rhs.icao24, file: file, line: line)
        XCTAssertEqual(lhs.callsign, rhs.callsign, file: file, line: line)
        XCTAssertEqual(lhs.originCountry, rhs.originCountry, file: file, line: line)
        XCTAssertEqual(lhs.timePosition, rhs.timePosition, file: file, line: line)
        XCTAssertEqual(lhs.lastContact, rhs.lastContact, file: file, line: line)
        XCTAssertEqual(lhs.longitude!, rhs.longitude!, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(lhs.latitude!, rhs.latitude!, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(lhs.altitude!, rhs.altitude!, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(lhs.isOnGround, rhs.isOnGround, file: file, line: line)
        XCTAssertEqual(lhs.velocity!, rhs.velocity!, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(lhs.trueTrack!, rhs.trueTrack!, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(lhs.verticalRate!, rhs.verticalRate!, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(lhs.sensors, rhs.sensors, file: file, line: line)
        XCTAssertEqual(lhs.geoAltitude!, rhs.geoAltitude!, accuracy: 0.001, file: file, line: line)
        XCTAssertEqual(lhs.squawk, rhs.squawk, file: file, line: line)
        XCTAssertEqual(lhs.isSPI, rhs.isSPI, file: file, line:line)
        XCTAssertEqual(lhs.positionSource, rhs.positionSource, file: file, line: line)
        XCTAssertEqual(lhs.category, rhs.category, file: file, line: line)
    }
}
