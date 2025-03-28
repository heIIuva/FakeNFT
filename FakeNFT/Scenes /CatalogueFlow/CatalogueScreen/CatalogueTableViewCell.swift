//
//  CatalogueTableViewCell.swift
//  FakeNFT
//
//  Created by Денис Максимов on 27.03.2025.
//

import UIKit
import Kingfisher

protocol CatalogueTableViewCellProtocol: UITableViewCell {
    func configure(image: String, title: String, count: Int)
}

final class CatalogueTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    
    private lazy var collectionImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .top
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    } ()
    
    private lazy var collectionTitle: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        return label
    } ()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        clipsToBounds = true
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionImage.kf.cancelDownloadTask()
    }
    
    private func setupUI() {
        [collectionImage, collectionTitle].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
            
            collectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionTitle.topAnchor.constraint(equalTo: collectionImage.bottomAnchor, constant: 4)
        ])
    }
}

// MARK: - Extensions

extension CatalogueTableViewCell: CatalogueTableViewCellProtocol {
    
    func configure(image: String, title: String, count: Int) {
        collectionTitle.text = "\(title) (\(count))"
        collectionImage.kf.indicatorType = .activity
        collectionImage.kf.setImage(
            with: URL(string: image),
            options: [.transition(.fade(1))],
            completionHandler: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let resultImage):
                    collectionImage.image = resultImage.image.resized(newWidth: collectionImage.bounds.width)
                case .failure(_):
                    break
                }
            }
        )
    }
}
