//
//  CatalogueService.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

protocol CatalogueServiceProtocol {
    func fetchCatalogue(completion: @escaping (Result<[NftCollection], Error>) -> Void)
}

final class CatalogueService: CatalogueServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchCatalogue(completion: @escaping (Result<[NftCollection], Error>) -> Void) {
        let request = CatalogueRequest()
        networkClient.send(request: request, type: [NftCollection].self, onResponse: completion)
    }
}
