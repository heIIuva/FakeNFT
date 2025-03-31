//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Денис Максимов on 30.03.2025.
//

import UIKit

final class NftCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .rating3))
        imageView.contentMode = .scaleAspectFit
        return imageView
    } ()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 108))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(resource: .nftGreenUniversal)
        return imageView
    } ()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .notLiked), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    } ()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.addArrangedSubview(nftNameLabel)
        stackView.addArrangedSubview(nftPriceLabel)
        return stackView
    } ()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.numberOfLines = 2
        label.text = "NFT name"
        return label
    } ()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.text = "1 ETH"
        return label
    } ()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .addToCart), for: .normal)
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        return button
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
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        [nftImageView, likeButton, ratingImageView, stackView, cartButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            ratingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 68),
//            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didTapLikeButton() {
        likeButton.setImage(
            likeButton.image(for: .normal) == UIImage(resource: .liked) ?
                UIImage(resource: .notLiked) :
                UIImage(resource: .liked), for: .normal
        )
    }
    @objc private func didTapCartButton() {
        cartButton.setImage(
            cartButton.image(for: .normal) == UIImage(resource: .addToCart) ?
                UIImage(resource: .deleteFromCart) :
                UIImage(resource: .addToCart), for: .normal
        )
    }
}
