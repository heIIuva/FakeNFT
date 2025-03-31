//
//  AvatarView.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 31.03.2025.
//

import UIKit
import Kingfisher

final class AvatarView: UIView {

    var onChoosePhoto: ((String) -> Void)?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = ProfileLayoutConstants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .yaBlack60
        view.layer.cornerRadius = ProfileLayoutConstants.avatarCornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = NSLocalizedString("EditProfile.changePhoto", comment: "")
        label.textColor = .white
        label.font = .caption3
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
        ])

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setupView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(overlayView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),
            imageView.heightAnchor.constraint(equalToConstant: ProfileLayoutConstants.avatarSize),

            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
    }

    func setImage(url: String) {
        if let url = URL(string: url) {
            imageView.kf.setImage(with: url)
        }
    }

    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }

    private func presentTextFieldAlert() {
        guard let viewController = self.findViewController() else { return }

        let alert = UIAlertController(title: NSLocalizedString("EditProfile.loadPhoto", comment: ""),
                                      message: nil,
                                      preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("EditProfile.photoUrlPlaceholder", comment: "")
            textField.keyboardType = .URL
            textField.autocapitalizationType = .none
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)

        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { [weak self] _ in
            guard let self = self,
                  let urlString = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let url = URL(string: urlString),
                  UIApplication.shared.canOpenURL(url)
            else {
                return
            }

            self.setImage(url: urlString)
            self.onChoosePhoto?(urlString)
        }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        viewController.present(alert, animated: true)
    }

    @objc private func tapped() {
        let title = NSLocalizedString("EditProfile.loadPhoto", comment: "")

        let items = [
            PopupMenuView.MenuItem(title: title, action: { [weak self] in
                self?.presentTextFieldAlert()
            }),
        ]

        let style = PopupMenuView.Style(
            backgroundColor: .background,
            cornerRadius: 16,
            font: .bodyRegular,
            textColor: .textPrimary,
            buttonBackgroundColor: .clear
        )

        PopupMenuView.show(
            under: self,
            in: self.superview ?? self,
            items: items,
            width: 250,
            style: style
        )
    }
}
