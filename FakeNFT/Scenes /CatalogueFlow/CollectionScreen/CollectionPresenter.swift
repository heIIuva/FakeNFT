//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject, NftCollectionCellDelegate, NftCollectionHeaderDelegate {
    func setupCollectionView(_ view: CollectionViewProtocol)
    func loadOrdersAndLikes()
    func getNftCount() -> Int
    func configure(cell: NftCollectionCellProtocol, for indexPath: IndexPath)
    func configure(header: NftCollectionHeader, withImage: Bool)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: CollectionViewProtocol?
    private let collection: NftCollection
    private let servicesAssembly: ServicesAssembly
    private let nftService: NftServiceProtocol
    private let collectionService: CollectionServiceProtocol
    private var orderedNfts: [String]?
    private var likedNfts: [String]?
    
    // MARK: - Init
    
    init(collection: NftCollection, servicesAssembly: ServicesAssembly) {
        self.collection = collection
        self.servicesAssembly = servicesAssembly
        self.nftService = servicesAssembly.nftService
        self.collectionService = servicesAssembly.collectionService
    }
    
    // MARK: - Methods
    
    func setupCollectionView(_ view: CollectionViewProtocol) {
        self.view = view
    }
    
    func loadOrdersAndLikes() {
        view?.shouldShowIndicator(true)
        collectionService.fetchOrders { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let orders):
                orderedNfts = orders.nfts
                shouldReloadView()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        collectionService.fetchProfile { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                likedNfts = profile.likes
                shouldReloadView()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func getNftCount() -> Int {
        collection.nfts.count
    }
    
    func configure(cell: NftCollectionCellProtocol, for indexPath: IndexPath) {
        cell.nftCellDelegate = self
        cell.isUserInteractionEnabled(false)
        nftService.loadNft(id: collection.nfts[indexPath.item]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nft):
                cell.configure(with: nft)
                cell.nftLiked(isNftLiked(nft.id))
                cell.nftAddedToCart(isNftInCart(nft.id))
                cell.isUserInteractionEnabled(true)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func configure(header: NftCollectionHeader, withImage: Bool) {
        header.nftHeaderViewDelegate = self
        header.configure(
            title: collection.name,
            author: collection.author,
            description: collection.description
        )
        if withImage { header.setImage(with: collection.cover) }
    }
    
    private func shouldReloadView() {
        if orderedNfts != nil && likedNfts != nil {
            view?.reloadData()
            view?.shouldShowIndicator(false)
        }
    }
    
    private func isNftLiked(_ nftId: String) -> Bool {
        likedNfts?.contains(nftId) ?? false
    }
    
    private func isNftInCart(_ nftId: String) -> Bool {
        orderedNfts?.contains(nftId) ?? false
    }
}

// MARK: - Extensions

extension CollectionPresenter: NftCollectionHeaderDelegate {
    
    func handleAuthorLinkButtonTap() {
        // Epic catalog 3/3 iteration
    }
}

extension CollectionPresenter: NftCollectionCellDelegate {
    
    func handleLikeButtonTap(for id: String, completion: @escaping (Bool) -> Void) {
        guard let likes = likedNfts else { return }
        let isLiked = isNftLiked(id)
        let updatedLikedNfts = isLiked ? likes.filter { $0 != id } : likes + [id]
        collectionService.updateProfile(with: updatedLikedNfts) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                likedNfts = profile.likes
                completion(!isLiked)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func handleCartButtonTap(for id: String) {
        
    }
}
