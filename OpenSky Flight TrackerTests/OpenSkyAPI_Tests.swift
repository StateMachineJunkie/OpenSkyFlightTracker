//
//  OpenSkyAPI_Tests.swift
//  OpenSky Flight TrackerTests
//
//  Created by Michael Crawford on 8/30/23.
//

import XCTest
@testable import OpenSky_Flight_Tracker

final class OpenSkyAPI_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getAllStateVectors_with_multiple_transponders() async throws {
        // Arrange
        // Act
        // Assert
    }

    func test_getAllStateVectors_with_single_transponder_success() {}
    func test_getAllStateVectors_with_single_transponder_fail() {}
    func test_getAllStateVectors_with_area() {}
    func test_getAllStateVectors_with_time() {}
    func test_getAllStateVectors_includingCategory() {}
    func test_getAllStateVectors_with_authentication() {}
}
