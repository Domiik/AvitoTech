//
//  MainCoordinator.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 08.09.2024.
//
import UIKit

protocol Coordinator {
    func start()
}

class MainCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController()
        searchViewController.coordinator = self
        navigationController.setViewControllers([searchViewController], animated: false)
    }
    
    func showDetail(for photo: UnsplashPhoto) {
        let detailViewController = DetailViewController(photo: photo)
        navigationController.pushViewController(detailViewController, animated: false)
    }
}
