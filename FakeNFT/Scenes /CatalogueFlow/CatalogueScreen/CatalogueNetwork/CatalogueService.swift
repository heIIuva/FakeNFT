//
//  CatalogueService.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

typealias NftCollectionCompletion = (Result<[NftCollection], Error>) -> Void

protocol CatalogueServiceProtocol {
    func fetchCatalogue(completion: @escaping NftCollectionCompletion)
}

final class CatalogueService: CatalogueServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchCatalogue(completion: @escaping NftCollectionCompletion) {
        let request = CatalogueRequest()
        networkClient.send(request: request, type: [NftCollection].self, onResponse: completion)
    }
}
