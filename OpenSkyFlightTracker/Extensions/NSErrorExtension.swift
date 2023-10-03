// 
// NSErrorExtension.swift
// OpenSkyFlightTracker
//
// Created by Michael Crawford on 10/10/23.
// Using Swift 5.0
//
// Copyright © 2021 Crawford Design Engineering, LLC. All rights reserved.
//

import Foundation

// Conform `NSError` based errors to `LocalizedError` so we can see them in our alert handler.
extension NSError: LocalizedError {
    public var errorDescription: String? {
        self.localizedDescription
    }

    public var failureReason: String? {
        self.localizedFailureReason
    }

    public var recoverySuggestion: String? {
        self.localizedRecoverySuggestion
    }
}
