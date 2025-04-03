//
//  ProfileCardView.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 27.03.2025.
//
import UIKit
import Kingfisher

final class ProfileCardView: UIView {
    
    private var urlString: String?
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "no_photo"))
        imageView.widthAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize).isActive = true
        imageView.layer.cornerRadius = ProfileLayoutConstants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = ProfileLayoutConstants.stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .caption2
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var openWebButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOpenWebView), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        
        if let website = profile.website {
            urlString = website
            openWebButton.setTitle(website, for: .normal)
            openWebButton.isHidden = false
        } else {
            openWebButton.setTitle(nil, for: .normal)
            openWebButton.isHidden = true
        }
        
        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.indicatorType = .activity
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "no_photo")
            )
        }
    }
    
    private func setupView() {
        [stackView, descriptionLabel, openWebButton].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ProfileLayoutConstants.horizontalPadding),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ProfileLayoutConstants.descriptionTop),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ProfileLayoutConstants.horizontalPadding),
            
            openWebButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: ProfileLayoutConstants.websiteButtonTop),
            openWebButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            openWebButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc private func didTapOpenWebView() {
        guard let urlString = urlString,
              let webVC = WebViewController(urlString: urlString)
        else { return }

        let navVC = UINavigationController(rootViewController: webVC)
        navVC.modalPresentationStyle = .fullScreen
        
        if let parentVC = self.parentViewController() {
            parentVC.present(navVC, animated: true)
        } else {
            print("could not find parent view controller")
        }
    }
}
