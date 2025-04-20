//
//  CollectionsViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 27.03.2025.
//

import UIKit

protocol CatalogueViewProtocol: UIViewController, LoadingView, ErrorView {
    func reloadData()
    func shouldShowIndicator(_ isShown: Bool)
}

final class CatalogueViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: CataloguePresenterProtocol
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(resource: .nftBlack)
        return indicator
    } ()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    } ()
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(resource: .sortButtonIcon)
                .withTintColor(
                    UIColor(resource: .nftBlack),
                    renderingMode: .alwaysOriginal),
            for: .normal)
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        return button
    } ()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = UIColor(resource: .nftWhite)
        tableView.register(CatalogueTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Init
    
    init(presenter: CataloguePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods of lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .nftWhite)
        setupUI()
        presenter.loadCatalogue(withIndicator: true)
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        [sortButton, tableView, activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        activityIndicator.constraintEdges(to: view)
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didPullToRefresh() {
        presenter.loadCatalogue(withIndicator: false)
    }
    
    @objc private func didTapSortButton() {
        let alertController = UIAlertController(
            title: Localizable.myNftSortTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        let actionByName = UIAlertAction(
            title: Localizable.sortName,
            style: .default,
            handler: { [weak self] _ in
                guard let self else { return }
                presenter.setSortingType(.byName)
            }
        )
        let actionByCount = UIAlertAction(
            title: Localizable.sortNftCount,
            style: .default,
            handler: { [weak self] _ in
                guard let self else { return }
                presenter.setSortingType(.byCount)
            }
        )
        let actionClose = UIAlertAction(
            title: Localizable.dismiss,
            style: .cancel
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
        refreshControl.endRefreshing()
    }
    
    func shouldShowIndicator(_ isShown: Bool) {
        tableView.isHidden = isShown
        isShown ? showLoading() :
                  hideLoading()
    }
}

extension CatalogueViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCollectionsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogueTableViewCell.defaultReuseIdentifier,
            for: indexPath)
        guard let catalogueCell = cell as? CatalogueTableViewCell else { return UITableViewCell() }
        return presenter.configure(cell: catalogueCell, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionPresenter = presenter.getCollectionPresenter(for: indexPath)
        let collectionVC = CollectionViewController(presenter: collectionPresenter)
        collectionPresenter.setupCollectionView(collectionVC)
        collectionVC.modalPresentationStyle = .fullScreen
        collectionVC.modalTransitionStyle = .crossDissolve
        present(collectionVC, animated: true)
    }
}
