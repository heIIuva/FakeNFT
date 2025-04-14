//
//  DeletionViewController.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 06.04.2025.
//

import UIKit
import Kingfisher

final class DeletionViewController: UIViewController {
    
    // MARK: - Init
    
    init(image: URL, action: @escaping () -> ()) {
        self.image = image
        self.onDeleteButtonTap = action
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let image: URL?
    private let onDeleteButtonTap: () -> ()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.kf.setImage(with: image)
        return imageView
    }()
    
    private lazy var confirmationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.text = Localizable.nftRemoveTitle
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localizable.delete, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = .label
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.addTarget(
            self,
            action: #selector(didTapDeleteButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localizable.backToCart, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = .label
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [deleteButton, backButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .clear
        
        let blur = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
        
        view.addSubviews(nftImageView, confirmationLabel, buttonStack)
        
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            
            confirmationLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            confirmationLabel.widthAnchor.constraint(equalToConstant: 200),
            confirmationLabel.heightAnchor.constraint(equalToConstant: 36),
            confirmationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStack.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 20),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.widthAnchor.constraint(equalToConstant: 230),
            buttonStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapDeleteButton() {
        onDeleteButtonTap()
        dismiss(animated: true)
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
}
