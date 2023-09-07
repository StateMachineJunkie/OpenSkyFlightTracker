//
//  MockURLProtocol.swift
//  OpenSky Flight TrackerTests
//
//  Created by Michael Crawford on 8/31/23.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (Data, HTTPURLResponse))?

    override class func canInit(with request: URLRequest) -> Bool { return true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { return request }
    override func stopLoading() {}

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else { return }
        do {
            let (data, response) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    static func loadJSONResource(named: String) throws -> Data {
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: named, withExtension: "json")!
        let data = try Data(contentsOf: url, options: .uncached)
        return data
    }
}
