//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 29.03.2025.
//
import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {

    private let profile: Profile

    // MARK: - UI

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = ProfileLayoutConstants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitle(NSLocalizedString("EditProfile.changePhoto", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .yaBlack60
        button.titleLabel?.font = .caption3
        button.layer.cornerRadius = ProfileLayoutConstants.avatarCornerRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let nameField = EditProfileViewController.createTextField(
        placeholder: NSLocalizedString("EditProfile.namePlaceholder", comment: "")
    )

    private let descriptionField = EditProfileViewController.createTextView()

    private let websiteField = EditProfileViewController.createTextField(
        placeholder: NSLocalizedString("EditProfile.websitePlaceholder", comment: "")
    )

    // MARK: - Init

    init(profile: Profile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .automatic
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        enableKeyboardDismissOnTap()
        setupView()
        fillData()
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(dismissTapped)
        )

        let avatarStack = UIView()
        avatarStack.translatesAutoresizingMaskIntoConstraints = false
        avatarStack.addSubview(avatarImageView)
        avatarStack.addSubview(changePhotoButton)

        view.addSubview(avatarStack)
        view.addSubview(nameField)
        view.addSubview(descriptionField)
        view.addSubview(websiteField)

        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: avatarStack.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: avatarStack.topAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),

            changePhotoButton.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            changePhotoButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),

            avatarStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            avatarStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarStack.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),

            nameField.topAnchor.constraint(equalTo: avatarStack.bottomAnchor, constant: 32),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 44),

            descriptionField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            descriptionField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            descriptionField.heightAnchor.constraint(equalToConstant: 132),

            websiteField.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 24),
            websiteField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            websiteField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            websiteField.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func fillData() {
        nameField.text = profile.name
        descriptionField.text = profile.description
        websiteField.text = profile.website

        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.setImage(with: url)
        }
    }

    // MARK: - Actions

    @objc private func dismissTapped() {
        dismiss(animated: true)
    }

    // MARK: - Helpers

    private static func createTextField(placeholder: String) -> UITextField {
        let field = InsetTextField(inset: ProfileLayoutConstants.textFieldInset)
        field.placeholder = placeholder
        field.font = .bodyRegular
        field.layer.cornerRadius = ProfileLayoutConstants.textFieldCornerRadius
        field.borderStyle = .none
        field.backgroundColor = .textField
        field.textColor = .textPrimary
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }

    private static func createTextView() -> UITextView {
        let textView = UITextView()
        textView.font = .bodyRegular
        textView.layer.cornerRadius = ProfileLayoutConstants.textFieldCornerRadius
        textView.backgroundColor = .textField
        textView.textColor = .textPrimary
        textView.textContainerInset = ProfileLayoutConstants.textFieldInset
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
}
