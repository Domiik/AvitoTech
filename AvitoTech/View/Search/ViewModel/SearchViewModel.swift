//
//  SearchViewModel.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 06.09.2024.
//


import UIKit

enum SortOption {
    case popularity
    case date
}

final class SearchViewModel {
    
    private let unsplashService: UnsplashServiceProtocol
    private var history: [String] = []
    private let placeholderImage: UIImage = UIImage(named: "plus") ?? UIImage()
    
    let mockData: [UnsplashPhoto] = []
    
    var errorHandler: ((AppError) -> Void)?
    
    init(unsplashService: UnsplashServiceProtocol) {
        self.unsplashService = unsplashService
    }
    
    var searchResults: [UnsplashPhoto] = []
    
    func search(query: String, completion: @escaping ([UnsplashPhoto]) -> Void) {
        if !history.contains(query) {
            if history.count == 5 {
                history.removeFirst()
            }
            history.append(query)
        }
        
        unsplashService.fetchImages(searchTerm: query) { [weak self] result, error  in
            guard let self = self else { return }
            
            if let error = error {
                self.errorHandler?(self.mapError(error))
                completion([])
                return
            }
            let photos = result?.results ?? []
            self.searchResults = photos
            completion(photos)
        }
    }
    
    private func mapError(_ error: Error) -> AppError {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return .noInternetConnection
        }
        return .unknownError
    }
    
    func getFilteredHistory(for query: String) -> [String] {
        return history.filter { $0.lowercased().contains(query.lowercased()) }
    }
    
    func getHistory() -> [String] {
        return history
    }
    
    
    func loadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completion(placeholderImage)
            return
        }
        
        completion(placeholderImage)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(loadedImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(self.placeholderImage)
                }
            }
        }.resume()
    }
    
    
    func sortResults(by option: SortOption) {
        switch option {
        case .popularity:
            searchResults.sort { $0.likes > $1.likes }
        case .date:
            searchResults.sort { $0.created_at > $1.created_at }
        }
    }
}
