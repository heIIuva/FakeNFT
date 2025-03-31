//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 31.03.2025.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject {
    var collection: NftCollection { get }
    func setupCollectionView(_ view: CollectionViewProtocol)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    // MARK: - Properties
    
    private(set) var collection: NftCollection
    private weak var view: CollectionViewProtocol?
    
    // MARK: - Init
    
    init(collection: NftCollection) {
        self.collection = collection
    }
    
    // MARK: - Methods
    
    func setupCollectionView(_ view: CollectionViewProtocol) {
        self.view = view
    }
}
