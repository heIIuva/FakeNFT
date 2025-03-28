//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(resource: .navBackButton).withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        return backButton
    } ()
    
    // MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .nftWhite)
        setupUI()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
    }
    
    @objc private func handleBackButtonTap() {
        dismiss(animated: true)
    }
}
