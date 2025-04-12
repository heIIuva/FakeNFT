//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Денис Максимов on 30.03.2025.
//

import UIKit
import Kingfisher

protocol NftCollectionCellProtocol: UICollectionViewCell {
    var nftCellDelegate: NftCollectionCellDelegate? { get set }
    func configure(with nft: Nft)
    func isUserInteractionEnabled(_ isEnabled: Bool)
    func nftLiked(_ isLiked: Bool)
    func nftAddedToCart(_ isInCart: Bool)
}

protocol NftCollectionCellDelegate: AnyObject {
    func handleLikeButtonTap(for id: String, completion: @escaping (Bool) -> Void)
    func handleCartButtonTap(for id: String)
}

final class NftCollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    weak var nftCellDelegate: NftCollectionCellDelegate?
    private var cellId: String = ""
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 108, height: 108))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        return imageView
    } ()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    } ()
    
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView()
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
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        return button
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
    
    // MARK: - Methods of lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.kf.cancelDownloadTask()
        cellId = ""
        nftImageView.image = nil
        nftNameLabel.text = nil
        nftPriceLabel.text = nil
        ratingImageView.image = nil
        cartButton.imageView?.image = nil
    }
    
    // MARK: - Methods
        
    private func setNftImage(with image: String) {
        let processor = DownsamplingImageProcessor(size: nftImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 12)
        let retry = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(10))
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(
            with: URL(string: image),
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
    
    @objc private func didTapLikeButton() {
        nftCellDelegate?.handleLikeButtonTap(for: cellId) { [weak self] isLiked in
            guard let self else { return }
            nftLiked(isLiked)
        }
    }
    @objc private func didTapCartButton() {
        nftCellDelegate?.handleCartButtonTap(for: cellId)
    }
}

// MARK: - Extensions

extension NftCollectionCell: NftCollectionCellProtocol {
    
    func configure(with nft: Nft) {
        cellId = nft.id
        nftNameLabel.text = nft.name
        nftPriceLabel.text = String(format: "%.2f ETH", nft.price)
        ratingImageView.image = UIImage(resource: .init(name: "rating\(nft.rating)", bundle: .main))
        setNftImage(with: nft.images.first ?? "")
    }
    
    func isUserInteractionEnabled(_ isEnabled: Bool) {
        contentView.isUserInteractionEnabled = isEnabled
    }
    
    func nftLiked(_ isLiked: Bool) {
        likeButton.setImage(UIImage(resource: isLiked ? .liked : .notLiked), for: .normal)
    }
    
    func nftAddedToCart(_ isInCart: Bool) {
        cartButton.setImage(UIImage(resource: isInCart ? .addToCart : .deleteFromCart), for: .normal)
    }
}
