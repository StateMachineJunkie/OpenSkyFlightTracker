// 
// ArrayExtensionTests.swift
// OpenSkyFlightTrackerTests
//
// Created by Michael Crawford on 9/27/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import XCTest
import OpenSkyAPI
@testable import OpenSkyFlightTracker

final class ArrayExtensionTests: XCTestCase {
    // DO NOT ALTER THIS DATA. If you do, you will break the test. I recorded these values using Charles.
    // There are duplicate coordinates at indexes 1, 40, 42, and 49. Two of these duplicates, duplicate not only the
    // coordinates but the entire structure, which I find interesting. I'm not sure why OpenSky-Network is duplicating
    // entire `Waypoint`s but it is happening.
    let jsonData = """
    {
        "icao24":"a4db2c",
        "callsign":"OXF7251 ",
        "startTime":1.695837419E9,
        "endTime":1.695840378E9,
        "path":[
            [1695837419,33.4471,-111.7444,304,223,false],
            [1695837419,33.4471,-111.7444,304,204,false],
            [1695837520,33.4111,-111.7639,609,205,false],
            [1695837539,33.4045,-111.7681,609,208,false],
            [1695837546,33.4023,-111.7695,914,206,false],
            [1695837658,33.37,-111.7881,914,204,false],
            [1695837687,33.3652,-111.7907,914,203,false],
            [1695837703,33.3623,-111.7922,914,202,false],
            [1695837723,33.3602,-111.7929,914,193,false],
            [1695837733,33.3592,-111.7932,914,190,false],
            [1695837812,33.3491,-111.7952,914,189,false],
            [1695838049,33.3292,-111.7992,1219,189,false],
            [1695838141,33.1507,-111.8404,1828,189,false],
            [1695838197,33.1257,-111.8463,1828,192,false],
            [1695838226,33.1137,-111.8496,1828,193,false],
            [1695838309,33.0802,-111.859,1828,193,false],
            [1695838369,33.0522,-111.8662,2133,191,false],
            [1695838379,33.0478,-111.8672,2133,190,false],
            [1695838507,32.9987,-111.8782,2133,190,false],
            [1695838605,32.9621,-111.8862,2438,189,false],
            [1695838628,32.9541,-111.8883,2438,194,false],
            [1695838644,32.9483,-111.8901,2438,195,false],
            [1695838662,32.9423,-111.8924,2438,197,false],
            [1695838687,32.9339,-111.8956,2438,198,false],
            [1695838695,32.9309,-111.8966,2438,193,false],
            [1695838737,32.9152,-111.9012,2743,192,false],
            [1695838747,32.9107,-111.9022,2743,190,false],
            [1695838756,32.9068,-111.9029,2743,187,false],
            [1695838767,32.9021,-111.9037,2743,186,false],
            [1695838802,32.8844,-111.9039,2743,159,false],
            [1695838809,32.8812,-111.9012,2743,143,false],
            [1695838820,32.876,-111.8968,2743,147,false],
            [1695838840,32.8667,-111.8899,2743,147,false],
            [1695838848,32.8627,-111.8869,2743,150,false],
            [1695838873,32.8504,-111.8789,2743,148,false],
            [1695838892,32.8417,-111.8722,2743,146,false],
            [1695838914,32.8319,-111.8645,2743,146,false],
            [1695838920,32.8288,-111.8619,2743,143,false],
            [1695839180,32.7098,-111.7574,2743,144,false],
            [1695839218,32.6916,-111.744,2743,148,false],
            [1695839218,32.6916,-111.744,2743,148,false],
            [1695839281,32.6617,-111.7216,2438,148,false],
            [1695839281,32.6617,-111.7216,2438,145,false],
            [1695839708,32.4694,-111.5594,1828,146,false],
            [1695839726,32.4612,-111.5534,1828,148,false],
            [1695839732,32.4584,-111.5514,1828,148,false],
            [1695839747,32.4518,-111.5468,1524,148,false],
            [1695839864,32.3989,-111.5072,1524,146,false],
            [1695839902,32.3836,-111.4941,1524,132,false],
            [1695839902,32.3836,-111.4941,1524,132,false],
            [1695839924,32.3755,-111.4843,1524,136,false],
            [1695839933,32.3722,-111.4807,1524,136,false],
            [1695839951,32.3655,-111.4726,1828,135,false],
            [1695839965,32.3602,-111.4662,1524,133,false],
            [1695839973,32.3571,-111.4624,1828,133,false],
            [1695839986,32.3527,-111.4566,1524,128,false],
            [1695839991,32.3507,-111.4537,1524,129,false],
            [1695840101,32.314,-111.4007,1524,129,false],
            [1695840108,32.3117,-111.3976,1524,138,false],
            [1695840116,32.308,-111.3946,1524,149,false],
            [1695840127,32.3025,-111.3915,1524,149,false],
            [1695840135,32.2987,-111.3897,1524,156,false],
            [1695840237,32.2506,-111.3655,1524,157,false],
            [1695840243,32.248,-111.3644,1524,160,false],
            [1695840268,32.236,-111.3591,1828,162,false],
            [1695840295,32.2229,-111.3539,1524,159,false],
            [1695840327,32.2081,-111.3471,1524,156,false],
            [1695840378,32.1829,-111.3359,1524,156,false]
        ]
    }
    """.data(using: .utf8)!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilterDuplicates() throws {
        let track = try JSONDecoder().decode(OpenSkyService.Track.self, from: jsonData)
        XCTAssertEqual(track.path.count, 68)
        let filteredPath = track.path.filteredDuplicates
        XCTAssertEqual(filteredPath.count, 66)
        let filteredPath2 = filteredPath.filteredDuplicates
        XCTAssertEqual(filteredPath, filteredPath2)
    }

    func testFilterDuplicateCoordinates() throws {
        let track = try JSONDecoder().decode(OpenSkyService.Track.self, from: jsonData)
        XCTAssertEqual(track.path.count, 68)
        let filteredPath = track.path.filteredDuplicateCoordinates
        XCTAssertEqual(filteredPath.count, 64)
        let filteredPath2 = filteredPath.filteredDuplicateCoordinates
        XCTAssertEqual(filteredPath, filteredPath2)
    }
}
