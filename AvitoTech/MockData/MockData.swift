//
//  MockData.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 07.09.2024.
//

import Foundation

class MockUnsplashService: UnsplashServiceProtocol {
    var shouldReturnError = false
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?, (any Error)?) -> ()) {
        if shouldReturnError {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
            completion(nil, error)
        } else {
            let mockPhotos = [UnsplashPhoto(description: "Mock data", user: User.init(name: "Mock user"), urls: [UnsplashPhoto.URLKing.regular.rawValue: "regular"] , likes: 1, created_at: "mock data")]
            let mockResults = SearchResults(total: 10, results: mockPhotos)
            completion(mockResults, nil)
        }
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var requestCalled = false
    var mockData: Data?
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        requestCalled = true
        if shouldReturnError {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
            completion(nil, error)
        } else {
            completion(mockData, nil)
        }
    }
}
