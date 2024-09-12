//
//  NetworkServiceTests.swift
//  AvitoTechTests
//
//  Created by Владимир Иванов on 12.09.2024.
//

import XCTest
@testable import AvitoTech

final class NetworkServiceTests: XCTestCase {
    
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
    }
    
    override func tearDown() {
        mockNetworkService = nil
        super.tearDown()
    }
    
    // Тест успешного запроса
    func testNetworkServiceSuccess() {
        // Ожидаемые данные
        let expectedData = "{\"results\": []}".data(using: .utf8)
        mockNetworkService.mockData = expectedData
        
        let expectation = XCTestExpectation(description: "Completion handler is called")
        
        mockNetworkService.request(searchTerm: "test") { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(data, expectedData)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.requestCalled)
    }
    
    // Тест на ошибку при запросе
    func testNetworkServiceFailure() {
        mockNetworkService.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Completion handler is called")
        
        mockNetworkService.request(searchTerm: "test") { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Mock error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.requestCalled)
    }
    
    // Тест на корректность заголовков и параметров
    func testNetworkServiceHeaderAndParameters() {
        let networkService = NetworkService()
        let headers = networkService.prepareHeader()
        XCTAssertEqual(headers?["Authorization"], "Client-ID mqXRsmmgUOgn0yw7tX5kdzCc2RjTz7ImeZod5vNiMpU")
        
        let parameters = networkService.prepareParaments(searchTerm: "test")
        XCTAssertEqual(parameters["query"], "test")
        XCTAssertEqual(parameters["page"], "1")
        XCTAssertEqual(parameters["per_page"], "30")
    }
}
