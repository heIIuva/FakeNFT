//
//  PaymentConfirmationViewController.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 13.04.2025.
//

import UIKit


final class PaymentConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backToCatalogueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .label
        button.setTitle(NSLocalizedString("BackToCatalog", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didTapBackToCatalogueButton), for: .touchUpInside)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        return button
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let image = UIImageView(image: UIImage(resource: .paymentSuccesful))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.frame = .init(x: .zero, y: .zero, width: 278, height: 278)
        return image
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Payment.successful", comment: "")
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var placeholderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeholderImage, placeholderLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalCentering
        return stack
    }()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - methods
    
    private func setupUI() {
        view.addSubviews(placeholderStack, backToCatalogueButton)
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            placeholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            placeholderStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            placeholderStack.heightAnchor.constraint(equalToConstant: 384),
            
            backToCatalogueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToCatalogueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backToCatalogueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backToCatalogueButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - OBJC-C methods
    
    @objc private func didTapBackToCatalogueButton() {
        tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: true)
    }
}
