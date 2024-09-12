//
//  UnsplashService.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 06.09.2024.
//

import UIKit

protocol UnsplashServiceProtocol {
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?, Error?) -> ())
}

class UnsplashService: UnsplashServiceProtocol {
    
    var networkService = NetworkService()
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?, Error?) -> ()) {
            networkService.request(searchTerm: searchTerm) { (data, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let decode = self.decodeJSON(type: SearchResults.self, from: data)
                completion(decode, nil)
            }
        }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
