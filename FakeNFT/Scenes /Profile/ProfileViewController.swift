//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 25.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {

    let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
    }

}
