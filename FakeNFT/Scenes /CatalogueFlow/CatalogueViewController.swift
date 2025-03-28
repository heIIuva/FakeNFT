//
//  CollectionsViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 27.03.2025.
//

import UIKit

protocol CatalogueViewProtocol: UIViewController {
    func reloadData()
    func showIndicator()
    func hideIndicator()
}

final class CatalogueViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: CataloguePresenterProtocol
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .init(resource: .nftBlack)
        return indicator
    } ()
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
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: CataloguePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Methods of lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .nftWhite)
        setupUI()
        setupNavBarAndTabBar()
        presenter.loadCatalogue()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        [tableView, indicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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

extension CatalogueViewController: CatalogueViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showIndicator() {
        tableView.isHidden = true
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func hideIndicator() {
        tableView.isHidden = false
        indicator.isHidden = true
        indicator.stopAnimating()
    }
}

extension CatalogueViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.collections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogueTableViewCell.defaultReuseIdentifier,
            for: indexPath)
        guard let catalogueCell = cell as? CatalogueTableViewCell else { return UITableViewCell() }
        let configuredCell = presenter.configure(cell: catalogueCell, for: indexPath)
        return configuredCell
    }
}
