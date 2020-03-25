//
//  NetworkingClientTests.swift
//  HeroSquadTests
//
//  Created by Dimitrios Chatzieleftheriou on 24/03/2020.
//  Copyright © 2020 Decimal Digital. All rights reserved.
//

import Foundation
import XCTest
@testable import HeroSquad

class NetworkingClientTests: XCTestCase {
    
    private let url = URL(string: "http://some.domain.com")!

    func test_Networking_Returns_DecodeData() {
        let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = MockData.validJSONData
        
        let sessionMock = MockNetworkingSession(response: response, data: data, error: nil)
        let sut = NetworkingClient(session: sessionMock)
        
        let endpoint = Endpoint<TestObject>(path: "/some/path")
        sut.request(endpoint, baseURL: self.url) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(response, value.response)
            case .failure: XCTFail()
            }
        }
    }
    
    func test_Networking_Returns_Error_onMalformedJSON() {
        let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = MockData.invalidJSONData
        
        let sessionMock = MockNetworkingSession(response: response, data: data, error: nil)
        let sut = NetworkingClient(session: sessionMock)
        
        let endpoint = Endpoint<TestObject>(path: "/some/path")
        sut.request(endpoint, baseURL: self.url) { result in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    XCTAssertEqual(networkError, NetworkError.decodingFailed)
                }
            }
        }
    }
    
    func test_Networking_Returns_Error() {
        let sessionMock = MockNetworkingSession(response: nil, data: nil, error: NetworkError.unknown)
        let sut = NetworkingClient(session: sessionMock)
        
        let endpoint = Endpoint<TestObject>(path: "/some/path")
        sut.request(endpoint, baseURL: self.url) { result in
            switch result {
            case .success: XCTFail()
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    XCTAssertEqual(networkError, NetworkError.unknown)
                }
            }
        }
    }

}

private struct TestObject: Codable {
    let title: String
}

private struct MockData {
    static var invalidJSONData: Data {
        return ".".data(using: .utf8)!
    }

    static var validJSONData: Data {
        return "{\"title\": \"Test object title\" }".data(using: .utf8)!
    }
}

class MockNetworkingSession: NetworkingSession {
    private var response: HTTPURLResponse?
    private var data: Data?
    private var error: Error?
    
    public init(response: HTTPURLResponse?, data: Data?, error: Error?) {
        self.response = response
        self.data = data
        self.error = error
    }
    
    func response(request: URLRequest, completion: @escaping (Result<(response: HTTPURLResponse, data: Data), Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        if let response = response, let data = data {
            completion(.success((response, data)))
        }
    }
}
