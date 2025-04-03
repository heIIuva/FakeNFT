//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Денис Максимов on 30.03.2025.
//

import UIKit
import Kingfisher

protocol NftCollectionViewCellProtocol: UICollectionViewCell {
    var nftCellDelegate: NftCollectionViewCellDelegate? { get }
    func configure(with id: String)
    func didTapLikeButton()
    func didTapCartButton()
}

final class NftCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var nftCellDelegate: NftCollectionViewCellDelegate?
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 108))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        return imageView
    } ()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .notLiked), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    } ()
    
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .rating0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    } ()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nftNameLabel, nftPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    } ()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.numberOfLines = 2
        return label
    } ()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
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
    
    // MARK: - Methods of lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
        nftImageView.image = nil
    }
    
    // MARK: - Methods
    
    private func configureDetails(with nft: Nft) {
        nftNameLabel.text = nft.name
        nftPriceLabel.text = String(format: "%.2f ETH", nft.price)
        ratingImageView.image = UIImage(resource: .init(name: "rating\(nft.rating)", bundle: .main))
        let processor = DownsamplingImageProcessor(size: nftImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 12)
        let retry = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(5))
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(
            with: URL(string: nft.images[0]),
            options: [.transition(.fade(1)), .processor(processor), .retryStrategy(retry)]
        )
    }
    
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
            stackView.widthAnchor.constraint(equalToConstant: 68),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - Extensions

extension NftCollectionViewCell: NftCollectionViewCellProtocol {
    
    func configure(with id: String) {
        UIProgressHUD.blockingShow()
        nftCellDelegate?.fetchNftDetails(for: id) { [weak self] result in
            UIProgressHUD.blockingDismiss()
            guard let self else { return }
            switch result {
            case .success(let nft):
                configureDetails(with: nft)
            case .failure:
                break
            }
        }
    }

    @objc func didTapLikeButton() {
        likeButton.setImage(
            likeButton.image(for: .normal) == UIImage(resource: .liked) ?
                UIImage(resource: .notLiked) :
                UIImage(resource: .liked), for: .normal
        )
    }
    @objc func didTapCartButton() {
        cartButton.setImage(
            cartButton.image(for: .normal) == UIImage(resource: .addToCart) ?
                UIImage(resource: .deleteFromCart) :
                UIImage(resource: .addToCart), for: .normal
        )
    }
}
