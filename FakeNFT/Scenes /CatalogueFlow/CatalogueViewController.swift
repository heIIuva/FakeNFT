//
//  CollectionsViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 27.03.2025.
//

import UIKit

final class CatalogueViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogueTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        return tableView
    }()
    
    // MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .nftWhite)
        setupUI()
        setupNavBarAndTabBar()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavBarAndTabBar() {
        tabBarController?.tabBar.isTranslucent = false
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .sortButtonIcon),
            style: .plain,
            target: self,
            action: nil)
    }
}

// MARK: - Extensions

extension CatalogueViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        CatalogueTableViewCell()
    }
}
