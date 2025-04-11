//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject, NftCollectionCellDelegate, NftCollectionHeaderDelegate {
    func setupCollectionView(_ view: CollectionViewProtocol)
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
    
    // MARK: - Init
    
    init(collection: NftCollection, servicesAssembly: ServicesAssembly) {
        self.collection = collection
        self.servicesAssembly = servicesAssembly
        self.nftService = servicesAssembly.nftService
    }
    
    // MARK: - Methods
    
    func setupCollectionView(_ view: CollectionViewProtocol) {
        self.view = view
    }
    
    func getNftCount() -> Int {
        collection.nfts.count
    }
    
    func configure(cell: NftCollectionCellProtocol, for indexPath: IndexPath) {
        cell.nftCellDelegate = self
        cell.isUserInteractionEnabled(false)
        nftService.loadNft(id: collection.nfts[indexPath.item]) { result in
            switch result {
            case .success(let nft):
                cell.configure(with: nft)
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
}

// MARK: - Extensions

extension CollectionPresenter: NftCollectionHeaderDelegate {
    
    func handleAuthorLinkButtonTap() {
        // Epic catalog 3/3 iteration
    }
}

extension CollectionPresenter: NftCollectionCellDelegate {
    
    func handleLikeButtonTap() {
        // Epic Catalog 3/3 iteration
    }
    
    func handleCartButtonTap() {
        // Epic Catalog 3/3 iteration
    }
}
