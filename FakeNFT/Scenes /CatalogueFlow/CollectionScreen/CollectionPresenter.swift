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
//        servicesAssembly.collectionService.fetchOrders { result in
//            switch result {
//            case .success(let orders):
//                print(orders)
//            case .failure(let error):
//                print("Orders fetch error: \(error.localizedDescription)")
//            }
//        }
//    ORDERS:
//        ["5093c01d-e79e-4281-96f1-76db5880ba70",
//         "ca34d35a-4507-47d9-9312-5ea7053994c0",
//         "739e293c-1067-43e5-8f1d-4377e744ddde"]
//        
//        servicesAssembly.collectionService.updateProfile(
//            with: ["739e293c-1067-43e5-8f1d-4377e744ddde",
//                   "5093c01d-e79e-4281-96f1-76db5880ba70",
//                   "28829968-8639-4e08-8853-2f30fcf09783",
//                   "7773e33c-ec15-4230-a102-92426a3a6d5a",
//                   "ca34d35a-4507-47d9-9312-5ea7053994c0"]
//        ) { result in
//            switch result {
//            case .success(let profile):
//                print(profile)
//            case .failure(let error):
//                print("Profile fetch error: \(error.localizedDescription)")
//            }
//            
//        }
//        servicesAssembly.collectionService.fetchProfile { result in
//            switch result {
//            case .success(let profile):
//                print(profile)
//            case .failure(let error):
//                print("Profile fetch error: \(error.localizedDescription)")
//            }
//        }
//        NFTS:
//        ["739e293c-1067-43e5-8f1d-4377e744ddde",
//         "5093c01d-e79e-4281-96f1-76db5880ba70",
//         "28829968-8639-4e08-8853-2f30fcf09783",
//         "7773e33c-ec15-4230-a102-92426a3a6d5a",
//         "ca34d35a-4507-47d9-9312-5ea7053994c0"]
//        LIKES:
//        ["5093c01d-e79e-4281-96f1-76db5880ba70",
//         "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
//         "83c23ccc-1368-4da8-b54d-76c9b235835b",
//         "739e293c-1067-43e5-8f1d-4377e744ddde"]
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
