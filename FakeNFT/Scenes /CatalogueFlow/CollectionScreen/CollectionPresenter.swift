//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject, NftCollectionViewCellDelegate {
    func setupCollectionView(_ view: CollectionViewProtocol)
    func getNftCount() -> Int
    func configure(cell: NftCollectionViewCell, for indexPath: IndexPath)
    func configure(header: NftCollectionSupplementaryView, withImage: Bool)
}

protocol NftCollectionViewCellDelegate: AnyObject {
    func fetchNftDetails(for nftId: String, completion: @escaping NftCompletion)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: CollectionViewProtocol?
    private let servicesAssembly: ServicesAssembly
    private let collection: NftCollection
    
    // MARK: - Init
    
    init(collection: NftCollection, servicesAssembly: ServicesAssembly) {
        self.collection = collection
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Methods
    
    func setupCollectionView(_ view: CollectionViewProtocol) {
        self.view = view
    }
    
    func getNftCount() -> Int {
        collection.nfts.count
    }
    
    func configure(cell: NftCollectionViewCell, for indexPath: IndexPath) {
        cell.nftCellDelegate = self
        cell.configure(with: collection.nfts[indexPath.item])
    }
    
    func configure(header: NftCollectionSupplementaryView, withImage: Bool) {
        header.configure(
            title: collection.name,
            author: collection.author,
            description: collection.description
        )
        if withImage { header.setImage(with: collection.cover) }
    }
}

// MARK: - Extensions

extension CollectionPresenter: NftCollectionViewCellDelegate {
    
    func fetchNftDetails(for nftId: String, completion: @escaping NftCompletion) {
        servicesAssembly.nftService.loadNft(id: nftId) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
