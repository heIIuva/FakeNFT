//
//  NftCollectionSupplementaryView.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import UIKit
import Kingfisher

protocol NftCollectionHeaderProtocol: UICollectionReusableView {
    var nftHeaderViewDelegate: NftCollectionHeaderDelegate? { get set }
    func configure(title: String, author: String, description: String)
    func setImage(with image: String)
}

protocol NftCollectionHeaderDelegate: AnyObject {
    func handleAuthorLinkButtonTap()
}

final class NftCollectionHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier: String = "header"
    weak var nftHeaderViewDelegate: NftCollectionHeaderDelegate?
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
        return label
    } ()
    
    private lazy var collectionAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.text = NSLocalizedString("Catalog.collectionAuthor", comment: "")
        return label
    } ()
    
    private lazy var collectionAuthorLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(resource: .nftBlueUniversal), for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.addTarget(self, action: #selector(handleAuthorLinkButtonTap), for: .touchUpInside)
        return button
    } ()
    
    private lazy var collectionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.numberOfLines = 0
        return label
    } ()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
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
    
    @objc private func handleAuthorLinkButtonTap() {
        nftHeaderViewDelegate?.handleAuthorLinkButtonTap()
    }
}

// MARK: - Extensions

extension NftCollectionHeader: NftCollectionHeaderProtocol {
    
    func configure(title: String, author: String, description: String) {
        collectionTitleLabel.text = title
        collectionAuthorLinkButton.setTitle(author, for: .normal)
        collectionDescriptionLabel.text = description
    }
    
    func setImage(with image: String) {
        let retry = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(10))
        collectionCoverImageView.kf.indicatorType = .activity
        collectionCoverImageView.kf.setImage(
            with: URL(string: image),
            options: [.transition(.fade(1)), .retryStrategy(retry)]
        )
    }
}
