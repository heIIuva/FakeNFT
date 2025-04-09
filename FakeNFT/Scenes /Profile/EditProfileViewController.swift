//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 29.03.2025.
//
import UIKit

final class EditProfileViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    weak var delegate: ProfileInteractionDelegate?
    private let profile: Profile
    
    private var initialAvatarURL: String = ""
    private var currentAvatarURL: String = ""
    private var initialName: String = ""
    private var initialDescription: String = ""
    private var initialWebsite: String = ""
    
    // MARK: - UI
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .iconPrimary
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var avatarView: AvatarView = {
        let view = AvatarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameField = createTextField()
    private let descriptionField = createTextView()
    private let websiteField = createTextField()
    
    // MARK: - Init
    init(profile: Profile) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .automatic
    }
    
    @available(*, unavailable)
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
        view.addSubview(avatarView)
        view.addSubview(formStack)
        
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileLayoutConstants.horizontalPadding),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ProfileLayoutConstants.horizontalPadding),
            closeButton.widthAnchor.constraint(equalToConstant: ProfileLayoutConstants.closeButtonSize),
            closeButton.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.closeButtonSize),
            
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ProfileLayoutConstants.avatarTopOffset),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),
            avatarView.widthAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),
            
            formStack.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: ProfileLayoutConstants.stackSpacing),
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
        
        initialAvatarURL = profile.avatar
        currentAvatarURL = profile.avatar
        initialName = profile.name
        initialDescription = profile.description ?? ""
        initialWebsite = profile.website ?? ""
        
        avatarView.setImage(url: profile.avatar)
        
        avatarView.onChoosePhoto = { [weak self] newURL in
            self?.currentAvatarURL = newURL
        }
    }
    
    private func handleDismissIfNeeded() {
        let currentName = nameField.text ?? ""
        let currentDescription = descriptionField.text ?? ""
        let currentWebsite = websiteField.text ?? ""

        let hasChanges = currentName != initialName ||
                         currentDescription != initialDescription ||
                         currentWebsite != initialWebsite ||
                         currentAvatarURL != initialAvatarURL

        if hasChanges {
            let updatedProfile = Profile(
                id: profile.id,
                name: currentName,
                avatar: currentAvatarURL,
                description: currentDescription.isEmpty ? nil : currentDescription,
                website: currentWebsite.isEmpty ? nil : currentWebsite,
                nfts: profile.nfts,
                likes: profile.likes
            )
            delegate?.didUpdateProfile(updatedProfile, completion: nil)
        }
    }
    
    //MARK: - UIAdaptivePresentationControllerDelegate
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        handleDismissIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func dismissTapped() {
        handleDismissIfNeeded()
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
