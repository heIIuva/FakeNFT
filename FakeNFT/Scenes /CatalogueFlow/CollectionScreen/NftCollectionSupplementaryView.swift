//
//  NftCollectionSupplementaryView.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import UIKit
import Kingfisher

final class NftCollectionSupplementaryView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier: String = "header"

    private lazy var collectionCoverImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .mockCollection))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    } ()
    
    private lazy var collectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.text = "Peach"
        return label
    } ()
    
    private lazy var collectionAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.text = "Автор коллекции:"
        return label
    } ()
    
    private lazy var collectionAuthorLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("John Doe", for: .normal)
        button.setTitleColor(UIColor(resource: .nftBlueUniversal), for: .normal)
        button.titleLabel?.font = UIFont.caption1
        return button
    } ()
    
    private lazy var collectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.numberOfLines = 0
        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
        return label
    } ()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(title: String, author: String, description: String) {
        collectionTitleLabel.text = title
        collectionAuthorLinkButton.setTitle(author, for: .normal)
        collectionDescriptionLabel.text = description
    }
    
    func setImage(with image: String) {
        collectionCoverImageView.kf.setImage(
            with: URL(string: image),
            options: [.transition(.fade(1))],
            completionHandler: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let resultImage):
                    collectionCoverImageView.image = resultImage.image
                case .failure:
                    collectionCoverImageView.backgroundColor = UIColor(resource: .nftBackgroundUniversal)
                }
            }
        )
    }
    
    private func setupUI() {
        backgroundColor = .clear
        [collectionCoverImageView,
         collectionTitleLabel,
         collectionAuthorLabel,
         collectionAuthorLinkButton,
         collectionDescriptionLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            collectionCoverImageView.heightAnchor.constraint(equalToConstant: 310),
            collectionCoverImageView.topAnchor.constraint(equalTo: topAnchor),
            collectionCoverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionCoverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionTitleLabel.topAnchor.constraint(equalTo: collectionCoverImageView.bottomAnchor, constant: 16),
            collectionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionTitleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            collectionAuthorLabel.topAnchor.constraint(equalTo: collectionTitleLabel.bottomAnchor, constant: 8),
            collectionAuthorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionAuthorLabel.heightAnchor.constraint(equalToConstant: 28),
            
            collectionAuthorLinkButton.leadingAnchor.constraint(equalTo: collectionAuthorLabel.trailingAnchor, constant: 4),
            collectionAuthorLinkButton.centerYAnchor.constraint(equalTo: collectionAuthorLabel.centerYAnchor),
            
            collectionDescriptionLabel.topAnchor.constraint(equalTo: collectionAuthorLabel.bottomAnchor),
            collectionDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}
