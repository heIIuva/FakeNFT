//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 07.04.2025.
//

import UIKit
import Kingfisher


final class CurrencyCell: UICollectionViewCell {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse identifier
    
    static let reuseIdentifier: String = "currencyCell"
    
    // MARK: - Properties
    
    private lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(resource: .nftLightGray)
        return view
    }()
    
    private lazy var logo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(resource: .nftGreen)
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, name])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
        
    // MARK: - configureCell
    
    func configureCell(currency: Currency) {
        logo.kf.setImage(with: currency.image, placeholder: UIImage(systemName: "photo"))
        title.text = currency.title
        name.text = currency.name
        background.layer.borderColor = UIColor.label.cgColor
    }
    
    func setSelected(_ selected: Bool) {
        background.layer.borderWidth = selected ? 1 : 0
    }
    
    // MARK: - Layout
    
    private func layoutCell() {
        addSubviews(background, logo, labelStack)
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.topAnchor.constraint(equalTo: topAnchor),
            background.widthAnchor.constraint(equalToConstant: 178),
            background.heightAnchor.constraint(equalToConstant: 46),
            
            logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            logo.centerYAnchor.constraint(equalTo: centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 36),
            logo.heightAnchor.constraint(equalToConstant: 36),
            
            labelStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 52),
            labelStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStack.heightAnchor.constraint(equalToConstant: 36),
            labelStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 41)
            
        ])
    }
}
