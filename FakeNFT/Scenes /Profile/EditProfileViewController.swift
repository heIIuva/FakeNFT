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
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .iconPrimary
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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
    
    private lazy var avatarContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(avatarImageView)
        container.addSubview(changePhotoButton)

        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: container.topAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),

            changePhotoButton.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            changePhotoButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
        ])

        return container
    }()

    private let nameField = EditProfileViewController.createTextField()

    private let descriptionField = EditProfileViewController.createTextView()

    private let websiteField = EditProfileViewController.createTextField()

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
        view.backgroundColor = .background

        // titles
        let nameTitle = makeTitleLabel(text: NSLocalizedString("EditProfile.nameTitle", comment: "Имя"))
        let descriptionTitle = makeTitleLabel(text: NSLocalizedString("EditProfile.descriptionTitle", comment: "Описание"))
        let websiteTitle = makeTitleLabel(text: NSLocalizedString("EditProfile.websiteTitle", comment: "Сайт"))
        let formStack = UIStackView(arrangedSubviews: [
            nameTitle, nameField,
            descriptionTitle, descriptionField,
            websiteTitle, websiteField
        ])
        formStack.axis = .vertical
        formStack.translatesAutoresizingMaskIntoConstraints = false

        formStack.setCustomSpacing(ProfileLayoutConstants.formStackSpacingSmall, after: nameTitle)
        formStack.setCustomSpacing(ProfileLayoutConstants.formStackSpacingLarge, after: nameField)
        formStack.setCustomSpacing(ProfileLayoutConstants.formStackSpacingSmall, after: descriptionTitle)
        formStack.setCustomSpacing(ProfileLayoutConstants.formStackSpacingLarge, after: descriptionField)
        formStack.setCustomSpacing(ProfileLayoutConstants.formStackSpacingSmall, after: websiteTitle)

        view.addSubview(closeButton)
        view.addSubview(avatarContainerView)
        view.addSubview(formStack)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ProfileLayoutConstants.horizontalPadding),
            closeButton.widthAnchor.constraint(equalToConstant: ProfileLayoutConstants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.closeButtonSize),
            
            avatarContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileLayoutConstants.avatarTopOffset),
            avatarContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarContainerView.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),

            formStack.topAnchor.constraint(equalTo: avatarContainerView.bottomAnchor, constant: ProfileLayoutConstants.stackSpacing),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ProfileLayoutConstants.horizontalPadding),

            nameField.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.rowHeight),
            descriptionField.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.descriptionHeight),
            websiteField.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.rowHeight),
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
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .headline3
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private static func createTextField() -> UITextField {
        let field = InsetTextField(inset: ProfileLayoutConstants.textFieldInset)
        field.font = .bodyRegular
        field.layer.cornerRadius = ProfileLayoutConstants.textFieldCornerRadius
        field.borderStyle = .none
        field.clearButtonMode = .whileEditing
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
