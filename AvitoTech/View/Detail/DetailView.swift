//
//  DetailView.swift
//  AvitoTech
//
//  Created by Владимир Иванов on 08.09.2024.
//
import UIKit

final class DetailView: UIView {
    
    lazy var imageView = createImageView()
    private lazy var descriptionLabel = createTitleLabel()
    private lazy var authorLabel = createAuthorLabel()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackViewButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        
        if descriptionLabel.text == "" {
            
        } else {
            addSubview(descriptionLabel)
            NSLayoutConstraint.activate([
                descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }
        
        
        if authorLabel.text == "" {
            
        } else {
            addSubview(authorLabel)
            NSLayoutConstraint.activate([
                authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            ])
        }
        
       
        
        addSubview(stackViewButtons)
        stackViewButtons.addArrangedSubview(saveButton)
        stackViewButtons.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 31)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.heightAnchor.constraint(equalToConstant: 31)
        ])
        
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            stackViewButtons.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackViewButtons.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    func configure(with photo: UnsplashPhoto) {
        descriptionLabel.text = photo.description ?? ""
        authorLabel.text = photo.user?.name ?? ""
    }
}


extension DetailView {
    
    func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textColor = .text
        return label
    }
    
    
    func createAuthorLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }
}
