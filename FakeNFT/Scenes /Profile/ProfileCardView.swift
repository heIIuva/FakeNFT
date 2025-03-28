//
//  ProfileCardView.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 27.03.2025.
//
import UIKit
import Kingfisher

final class ProfileCardView: UIView {

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
        label.text = "Joaquin Phoenix"
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
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        label.numberOfLines = 0
        label.font = .caption2
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("JoaquinPhoenix.com", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
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

    private func setupView() {
        [stackView, descriptionLabel, websiteButton].forEach(addSubview)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ProfileLayoutConstants.horizontalPadding),

            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ProfileLayoutConstants.descriptionTop),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ProfileLayoutConstants.horizontalPadding),

            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: ProfileLayoutConstants.websiteButtonTop),
            websiteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            websiteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension ProfileCardView {
    func configure(with profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description

        if let website = profile.website {
            websiteButton.setTitle(website, for: .normal)
            websiteButton.isHidden = false
        } else {
            websiteButton.setTitle(nil, for: .normal)
            websiteButton.isHidden = true
        }

        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.indicatorType = .activity
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "no_photo")
            )
        }
    }
}
