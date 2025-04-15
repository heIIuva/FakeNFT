//
//  CustomNavigationController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 27.03.2025.
//

import UIKit

class CustomNavigationController: UINavigationController {

    func pushViewController(
        _ viewController: UIViewController,
        title: String? = nil,
        showBackButton: Bool = true,
        animated: Bool = true
    ) {
        configureNavigationItem(
            for: viewController,
            title: title,
            showBackButton: showBackButton
        )
        super.pushViewController(viewController, animated: animated)
    }

    private func configureNavigationItem(
        for viewController: UIViewController,
        title: String?,
        showBackButton: Bool
    ) {
        viewController.navigationItem.title = title

        if showBackButton {
            let backImage = UIImage(systemName: "chevron.left")
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
            viewController.navigationItem.leftBarButtonItem = backButton
        } else {
            viewController.navigationItem.hidesBackButton = true
        }
    }

    @objc private func backButtonTapped() {
        popViewController(animated: true)
    }
}
