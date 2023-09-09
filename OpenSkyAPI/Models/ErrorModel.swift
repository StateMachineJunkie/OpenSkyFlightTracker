//
//  ErrorModel.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 9/7/23.
//

import Foundation

extension OpenSkyService {
    public struct ErrorModel: Codable, Equatable, Hashable {
        let timestamp: UInt
        let status: Int
        let error: String
        let message: String
        let path: String
    }
}
