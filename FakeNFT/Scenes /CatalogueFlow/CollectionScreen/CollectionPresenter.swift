//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject, NftCollectionCellDelegate, NftCollectionHeaderDelegate {
    func setupCollectionView(_ view: CollectionViewProtocol)
    func fetchData()
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
    private var collectionNfts: [Nft] = []
    private var orderedNfts: [String] = []
    private var likedNfts: [String] = []
    
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
    
    func getNftCount() -> Int {
        collectionNfts.count
    }
    
    func configure(cell: NftCollectionCellProtocol, for indexPath: IndexPath) {
        let nft = collectionNfts[indexPath.row]
        cell.nftCellDelegate = self
        cell.isUserInteractionEnabled(false)
        cell.configure(with: nft)
        cell.nftLiked(isNftLiked(nft.id))
        cell.nftAddedToCart(isNftInCart(nft.id))
        cell.isUserInteractionEnabled(true)
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
    
    private func isNftLiked(_ nftId: String) -> Bool {
        likedNfts.contains(nftId)
    }
    
    private func isNftInCart(_ nftId: String) -> Bool {
        orderedNfts.contains(nftId)
    }
    
    func fetchData() {
        var nfts: [Nft] = []
        var orders: [String] = []
        var likes: [String] = []
        let group = DispatchGroup()
        view?.shouldShowIndicator(true)
        
        for nft in collection.nfts{
            group.enter()
            nftService.loadNft(id: nft) { result in
                defer{ group.leave() }
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            }
        }
        group.enter()
        collectionService.fetchOrders { result in
            defer{ group.leave() }
            switch result {
            case .success(let orderedNfts):
                orders.append(contentsOf: orderedNfts.nfts)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        group.enter()
        collectionService.fetchProfile { result in
            defer{ group.leave() }
            switch result {
            case .success(let profile):
                likes.append(contentsOf: profile.likes)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            collectionNfts = nfts.sorted { $0.id < $1.id }
            orderedNfts = orders
            likedNfts = likes
            view?.reloadData()
            view?.shouldShowIndicator(false)
        }
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
        let isLiked = isNftLiked(id)
        let updatedLikedNfts = isLiked ? likedNfts.filter { $0 != id } : likedNfts + [id]
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
    
    func handleCartButtonTap(for id: String, completion: @escaping (Bool) -> Void) {
        let isInCart = isNftInCart(id)
        let updatedLikedNfts = isInCart ? orderedNfts.filter { $0 != id } : orderedNfts + [id]
        collectionService.updateOrders(with: updatedLikedNfts) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let orders):
                orderedNfts = orders.nfts
                completion(!isInCart)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
