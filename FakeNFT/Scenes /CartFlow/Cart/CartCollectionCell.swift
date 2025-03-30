//
//  CartCollectionCell.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 28.03.2025.
//

import UIKit


final class CartCollectionCell: UITableViewCell {
    
    // MARK: - Reuse Identifier
    
    static let reuseIdentifier: String = "cartCell"
        
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutCell()
    }
    
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
        return image
    }()
    
    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    }()
    
    // MARK: - Public methods
    
    func configureCell(nftPreview: ) {
        
    }
    
    // MARK: - Private methods
    
    private func layoutCell() {
        addSubviews(nftPreview, nftName, ratingLabel, priceLabel, priceTag, deleteButton)
        
        NSLayoutConstraint.activate([
            nftPreview.heightAnchor.constraint(equalToConstant: 108),
            nftPreview.widthAnchor.constraint(equalToConstant: 108),
            nftPreview.topAnchor.constraint(equalTo: topAnchor),
            nftPreview.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            nftName.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            nftName.topAnchor.constraint(equalTo: topAnchor, constant: -8),
            
            ratingLabel.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            ratingLabel.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: -4),
            
            priceLabel.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: -12),
            
            priceTag.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            priceTag.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -2),
            
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 195)
        ])
    }
    
    @objc func deleteButtonTapped() {}
}
