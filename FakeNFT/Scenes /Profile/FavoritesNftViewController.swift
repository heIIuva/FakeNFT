//
//  FavoritesNftViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 07.04.2025.
//

import UIKit

final class FavoritesNftViewController: UIViewController {

    private let servicesAssembly: ServicesAssembly
    private let nftIDs: [String]

    private lazy var presenter: MyNftPresenter = {
        MyNftPresenter(
            view: self,
            nftService: servicesAssembly.nftService,
            nftIDs: nftIDs
        )
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NftCollectionViewCell.self, forCellWithReuseIdentifier: NftCollectionViewCell.identifier)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас ещё нет избранных NFT"
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.font = .bodyBold
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    // MARK: - Init

    init(servicesAssembly: ServicesAssembly, nftIDs: [String]) {
        self.servicesAssembly = servicesAssembly
        self.nftIDs = nftIDs
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Избранные NFT"

        setupBackButton()
        setupUI()

        if nftIDs.isEmpty {
            showEmptyLabel()
        } else {
            presenter.viewDidLoad()
        }
    }

    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func showEmptyLabel() {
        emptyLabel.isHidden = false
        collectionView.isHidden = true
    }

    private func setupBackButton() {
        guard let backImage = UIImage(named: "backward") else { return }
        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        if navigationController?.viewControllers.first == self {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NftCollectionViewCell.identifier,
            for: indexPath
        ) as? NftCollectionViewCell else {
            return UICollectionViewCell()
        }

        let nft = presenter.item(at: indexPath.row)
        cell.configure(with: nft)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesNftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpacing: CGFloat = 12
        let sideInset: CGFloat = 16
        let availableWidth = collectionView.bounds.width - sideInset * 2 - horizontalSpacing
        let itemWidth = floor(availableWidth / 2)
        
        let itemHeight: CGFloat = 80

        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - MyNftView

extension FavoritesNftViewController: MyNftView {
    func reloadData() {
        collectionView.reloadData()
    }
}
