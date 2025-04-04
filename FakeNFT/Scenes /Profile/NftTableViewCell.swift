//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 04.04.2025.
//
import UIKit
import Kingfisher

final class NftTableViewCell: UITableViewCell {

    static let identifier = "NftCell"

    // MARK: - UI Elements
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.text = NSLocalizedString("NftViewCell.price", comment: "")
        return label
    }()

    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        return label
    }()

    private lazy var ratingView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, ratingView, authorLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var priceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceLabel, price])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupCell() {
        selectionStyle = .none

        contentView.addSubview(nftImageView)
        contentView.addSubview(textStack)
        contentView.addSubview(priceStack)

        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),

            textStack.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            priceStack.leadingAnchor.constraint(equalTo: textStack.trailingAnchor, constant: 39),
            priceStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration

    func configure(with nft: Nft) {
        nameLabel.text = nft.nftTitle
        authorLabel.text = "\(NSLocalizedString("NftViewCell.from", comment: "")) \(nft.name)"
        price.text = String(format: "%.2f ETH", nft.price)

        if let firstImageURL = nft.images.first {
            nftImageView.kf.setImage(with: firstImageURL)
        }

        ratingView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        (1...5).forEach { index in
            let isActive = index <= nft.rating
            let image = UIImage(named: isActive ? "stars_active" : "stars_no_active")
            
            let starImageView = UIImageView(image: image)
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = isActive ? .segmentInactive : nil
            
            ratingView.addArrangedSubview(starImageView)
        }
    }
}
