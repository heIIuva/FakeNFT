//
//  CartCollectionCell.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 28.03.2025.
//

import UIKit
import Kingfisher


final class CartTableViewCell: UITableViewCell {
    
    // MARK: - Reuse Identifier
    
    static let reuseIdentifier: String = "cartCell"
        
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private lazy var cellBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var nftPreview: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var priceTag: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(deleteButtonTapped),
            for: .touchUpInside)
        button.setImage(UIImage(resource: .cartDeleteButton), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private var onDeleteButtonTap: () -> () = {}
    
    // MARK: - Public methods
    
    func configureCell(nft: Nft, action: @escaping () -> ()) {
        nftPreview.kf.setImage(with: nft.images[0], placeholder: UIImage(systemName: "photo"))
        nftName.text = nft.name
        priceLabel.text = NSLocalizedString("Price", comment: "")
        priceTag.text = "\(nft.price) ETH"
        configureRatingStack(rating: nft.rating)
        self.onDeleteButtonTap = action
    }
    
    // MARK: - Private methods
    
    private func layoutCell() {
        addSubviews(nftPreview, nftName, ratingStack, priceLabel, priceTag)
        contentView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            nftPreview.heightAnchor.constraint(equalToConstant: 108),
            nftPreview.widthAnchor.constraint(equalToConstant: 108),
            nftPreview.topAnchor.constraint(equalTo: topAnchor),
            nftPreview.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            nftName.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            nftName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            ratingStack.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            ratingStack.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: 4),
            
            priceLabel.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 12),
            
            priceTag.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            priceTag.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 34),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureRatingStack(rating: Int) {
        ratingStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        for pos in 1...5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 12)))
            if pos <= rating {
                starImageView.tintColor = .systemYellow
            } else {
                starImageView.tintColor = UIColor(resource: .nftLightGray)
            }
            ratingStack.addArrangedSubview(starImageView)
        }
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteButtonTap()
    }
}
