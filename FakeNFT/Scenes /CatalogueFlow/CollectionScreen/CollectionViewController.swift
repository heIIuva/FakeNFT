//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import UIKit

protocol CollectionViewProtocol: UIViewController, LoadingView, ErrorView {
    func reloadData()
}

final class CollectionViewController: UIViewController, CollectionViewProtocol {
    
    
    // MARK: - Properties
    
    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    private let presenter: CollectionPresenterProtocol
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(resource: .navBackButton).withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(handleBackButtonTap), for: .touchUpInside)
        return backButton
    } ()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(NftCollectionViewCell.self)
        collectionView.register(
            NftCollectionSupplementaryView .self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NftCollectionSupplementaryView.identifier)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods of lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .nftWhite)
        setupUI()
    }
    
    // MARK: - Methods
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func setupUI() {
        [collectionView, backButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func handleBackButtonTap() {
        dismiss(animated: true)
    }
    
    @objc private func handleAuthorButtonTap() {
        // TODO: WebView implementation
    }
}

// MARK: - Extensions

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.collection.nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NftCollectionViewCell.defaultReuseIdentifier,
            for: indexPath) as? NftCollectionViewCell
        else { return UICollectionViewCell() }
        cell.nftCellDelegate = presenter
        cell.configure(with: presenter.collection.nfts[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NftCollectionSupplementaryView.identifier,
            for: indexPath) as? NftCollectionSupplementaryView
        else { return UICollectionReusableView() }
        headerView.configure(
            title: presenter.collection.name,
            author: presenter.collection.author,
            description: presenter.collection.description)
        headerView.setImage(with: presenter.collection.cover)
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
        let headerView = NftCollectionSupplementaryView()
        headerView.configure(
            title: presenter.collection.name,
            author: presenter.collection.author,
            description: presenter.collection.description)
        let size = headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.bounds.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}
