//
//  FavoritesNftViewController.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 07.04.2025.
//

import UIKit

final class FavoritesNftViewController: UIViewController {
    weak var delegate: ProfileInteractionDelegate?
    
    private let servicesAssembly: ServicesAssembly
    private let nftIDs: [String]
    
    private lazy var presenter: NftPresenter = {
        NftPresenter(
            view: self,
            services: servicesAssembly,
            nftIDs: nftIDs
        )
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = FavoritesLayoutConstants.collectionInterItemSpacing
        layout.minimumLineSpacing = FavoritesLayoutConstants.collectionLineSpacing
        layout.estimatedItemSize = .zero
        layout.sectionInset = FavoritesLayoutConstants.collectionSectionInset
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NftCollectionViewCell.self, forCellWithReuseIdentifier: NftCollectionViewCell.identifier)
        cv.backgroundColor = .background
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("FavoritesNft.placeholder", comment: "")
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
        view.backgroundColor = .background
        navigationItem.title = NSLocalizedString("FavoritesNft.title", comment: "")
        
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
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FavoritesLayoutConstants.emptyLabelHorizontalInset),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FavoritesLayoutConstants.emptyLabelHorizontalInset)
        ])
    }
    
    private func showEmptyLabel() {
        emptyLabel.isHidden = false
        collectionView.isHidden = true
    }
    
    private func setupBackButton() {
        guard let backImage = UIImage(named: "backward") else { return }
        let backButton = UIBarButtonItem(
            image: backImage,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func removeLike(withID id: String) {
        var updatedLikes = presenter.nftIDs
        guard let index = updatedLikes.firstIndex(of: id) else { return }
        updatedLikes.remove(at: index)
        
        delegate?.didUpdateLikes(updatedLikes) { [weak self] updatedProfile in
            guard let self = self else { return }
            
            let newLikes = updatedProfile?.likes ?? updatedLikes
            self.presenter.updateNftIDs(newLikes)
            
            if newLikes.isEmpty {
                self.showEmptyLabel()
            }
        }
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
        
        cell.onLikeTapped = { [weak self] in
            self?.removeLike(withID: nft.id)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesNftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing = FavoritesLayoutConstants.collectionInterItemSpacing
        let inset = FavoritesLayoutConstants.collectionSectionInset.left
        let numberOfColumns = FavoritesLayoutConstants.numberOfColumns
        
        let totalSpacing = (numberOfColumns - 1) * spacing
        let totalInsets = inset * 2
        let availableWidth = collectionView.bounds.width - totalInsets - totalSpacing
        let itemWidth = floor(availableWidth / numberOfColumns)
        let itemHeight = FavoritesLayoutConstants.cellHeight
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - MyNftView
extension FavoritesNftViewController: NftView {
    func reloadData() {
        collectionView.reloadData()
    }
}
