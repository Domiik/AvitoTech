//
//  DetailViewModel.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 11.09.2024.
//

import UIKit

final class DetailViewModel {
    private let unsplashService: UnsplashServiceProtocol
    private let placeholderImage: UIImage = UIImage(named: "plus") ?? UIImage()
    
    var image: UIImage?

    init(unsplashService: UnsplashServiceProtocol) {
        self.unsplashService = unsplashService
    }
    
    func loadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completion(placeholderImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                self.image = loadedImage
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
}
