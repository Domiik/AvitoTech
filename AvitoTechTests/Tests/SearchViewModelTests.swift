//
//  SearchViewModelTests.swift
//  AvitoTechTests
//
//  Created by Владимир Иванов on 12.09.2024.
//

import XCTest
@testable import AvitoTech

final class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    var mockService: MockUnsplashService!
    
    override func setUp() {
        super.setUp()
        mockService = MockUnsplashService()
        viewModel = SearchViewModel(unsplashService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    // Тест успешного получения данных
    func testSearchSuccess() {
        let expectation = XCTestExpectation(description: "Search completes successfully")
        
        viewModel.search(query: "Test") { photos in
            XCTAssertEqual(photos.count, 1)
            XCTAssertEqual(photos.first?.description, "Mock data")
            XCTAssertEqual(photos.first?.likes, 1)
            XCTAssertEqual(photos.first?.created_at, "mock data")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Тест на ошибку при запросе
    func testSearchFailure() {
        mockService.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Search fails with error")
        
        viewModel.errorHandler = { error in
            XCTAssertEqual(error.localizedDescription, "Произошла неизвестная ошибка. Попробуйте еще раз позже.")
            expectation.fulfill()
        }
        
        viewModel.search(query: "Test") { photos in
            XCTAssertTrue(photos.isEmpty)
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
