//
//  ArrayExtension.swift
//  OpenSky Flight Tracker
//
//  Created by Michael Crawford on 8/29/23.
//

import Foundation

extension Array where Element: LosslessStringConvertible {
    public func queryItems(withKey key: String) -> [URLQueryItem] {
        let queryItems: [URLQueryItem] = self.compactMap { element in
            return URLQueryItem(name: key, value: String(element))
        }
        return queryItems
    }
}
