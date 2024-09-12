//
//  DetailViewController.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 08.09.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    private let photo: UnsplashPhoto
    private let viewModel: DetailViewModel = DetailViewModel(unsplashService: UnsplashService())
    
    init(photo: UnsplashPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupButtons()
    }
    
    private func setupButtons() {
        detailView.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        detailView.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc private func share() {
        guard let image = viewModel.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func save() {
        guard let image = viewModel.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let message: String
        if let error = error {
            message = "Не удалось сохранить изображение: \(error.localizedDescription)"
        } else {
            message = "Изображение успешно сохранено в галерею!"
        }
        let alertController = UIAlertController(title: "Сохранение", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func configureView() {
        detailView.configure(with: photo)
        viewModel.loadImage(imageUrl: photo.urls["regular"] ?? "") { [weak self] image in
            self?.detailView.imageView.image = image
        }
    }
}
