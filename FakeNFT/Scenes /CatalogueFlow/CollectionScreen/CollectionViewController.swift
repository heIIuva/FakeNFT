//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import UIKit
import SafariServices

protocol CollectionViewProtocol: UIViewController, ErrorView, LoadingView {
    func showCollectionAuthorPage(_ url: URL)
    func reloadData()
    func shouldShowIndicator(_ isShown: Bool)
}

final class CollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: CollectionPresenterProtocol
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor(resource: .nftBlack)
        return activityIndicator
    } ()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    } ()
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(
            UIImage(resource: .navBackButton)
                .withTintColor(
                    UIColor(resource: .nftBlack),
                    renderingMode: .alwaysOriginal),
            for: .normal)
        backButton.imageView?.tintColor = UIColor(resource: .nftBlack)
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        return backButton
    } ()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.refreshControl = refreshControl
        collectionView.backgroundColor = UIColor(resource: .nftWhite)
        collectionView.register(NftCollectionCell.self)
        collectionView.register(
            NftCollectionHeader .self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NftCollectionHeader.identifier)
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    } ()
    
    // MARK: - Init
    
    init(presenter: CollectionPresenterProtocol) {
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
        presenter.fetchData()
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        [collectionView, activityIndicator, backButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        activityIndicator.constraintEdges(to: view)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didPullToRefresh() {
        refreshControl.endRefreshing()
        presenter.fetchData()
    }
    
    @objc private func handleBackButtonTap() {
        dismiss(animated: true)
    }
}

// MARK: - Extensions

extension CollectionViewController: CollectionViewProtocol {
    
    func showCollectionAuthorPage(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func shouldShowIndicator(_ isShown: Bool) {
        collectionView.isUserInteractionEnabled = !isShown
        isShown ? showLoading() :
                  hideLoading()
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.getNftCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NftCollectionCell.defaultReuseIdentifier,
            for: indexPath) as? NftCollectionCell
        else { return UICollectionViewCell() }
        presenter.configure(cell: cell, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NftCollectionHeader.identifier,
            for: indexPath) as? NftCollectionHeader
        else { return UICollectionReusableView() }
        presenter.configure(header: headerView, withImage: true)
        return headerView
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = NftCollectionHeader()
        presenter.configure(header: headerView, withImage: false)
        let size = headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.bounds.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}
