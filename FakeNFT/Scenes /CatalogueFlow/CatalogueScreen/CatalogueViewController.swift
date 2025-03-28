//
//  CollectionsViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 27.03.2025.
//

import UIKit

protocol CatalogueViewProtocol: UIViewController, LoadingView, ErrorView {
    func reloadData()
    func isShowIndicator(_ isShow: Bool)
}

final class CatalogueViewController: UIViewController, LoadingView, ErrorView {
    
    // MARK: - Properties
    
    private let presenter: CataloguePresenterProtocol
    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .sortButtonIcon), for: .normal)
        button.addTarget(self, action: #selector(handleSortButton), for: .touchUpInside)
        return button
    } ()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogueTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
        presenter.loadCatalogue()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        [sortButton, tableView, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func handleSortButton() {
        let alertController = UIAlertController(
            title: NSLocalizedString("SortActionSheet.title", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        let actionByName = UIAlertAction(
            title: NSLocalizedString("SortActionSheet.byName", comment: ""),
            style: .default,
            handler: { _ in }
        )
        let actionByCount = UIAlertAction(
            title: NSLocalizedString("SortActionSheet.byCount", comment: ""),
            style: .default,
            handler: { _ in }
        )
        let actionClose = UIAlertAction(
            title: NSLocalizedString("SortActionSheet.close", comment: ""),
            style: .cancel,
            handler: { _ in }
        )
        [actionByName, actionByCount, actionClose].forEach {
            alertController.addAction($0)
        }
        present(alertController, animated: true)
    }
}

// MARK: - Extensions

extension CatalogueViewController: CatalogueViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func isShowIndicator(_ isShow: Bool) {
        isShow ? showLoading() : hideLoading()
        view.isUserInteractionEnabled = !isShow
    }
}

extension CatalogueViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.catalogue.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionVC = CollectionViewController()
        collectionVC.modalPresentationStyle = .fullScreen
        collectionVC.modalTransitionStyle = .crossDissolve
        present(collectionVC, animated: true)
    }
}
