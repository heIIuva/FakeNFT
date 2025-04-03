//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject, NftCollectionViewCellDelegate {
    var collection: NftCollection { get }
    var servicesAssembly: ServicesAssembly { get }
    func setupCollectionView(_ view: CollectionViewProtocol)
}

protocol NftCollectionViewCellDelegate: AnyObject {
    func fetchNftDetails(for nftId: String, completion: @escaping NftCompletion)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: CollectionViewProtocol?
    private(set) var servicesAssembly: ServicesAssembly
    private(set) var collection: NftCollection
    
    // MARK: - Init
    
    init(collection: NftCollection, servicesAssembly: ServicesAssembly) {
        self.collection = collection
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Methods
    
    func setupCollectionView(_ view: CollectionViewProtocol) {
        self.view = view
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
