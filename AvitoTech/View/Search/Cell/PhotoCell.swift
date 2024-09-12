//
//  PhotoCell.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 06.09.2024.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6)
        ])
        
        if descriptionLabel.text == "" {}
        else {
            contentView.addSubview(descriptionLabel)
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
        }
      
        if authorLabel.text == "" {}
        else {
            contentView.addSubview(authorLabel)
            NSLayoutConstraint.activate([
                authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
                authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
                authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
            ])
        }
    }
    
    func configure(with photo: UnsplashPhoto, viewModel: SearchViewModel) {
        descriptionLabel.text = photo.description ?? ""
        authorLabel.text = photo.user?.name ?? ""
        
        viewModel.loadImage(imageUrl: photo.urls["regular"] ?? "") { [weak self] image in
            self?.imageView.image = image
        }
    }
}
