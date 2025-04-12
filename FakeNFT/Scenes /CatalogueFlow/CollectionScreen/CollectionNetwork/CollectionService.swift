//
//  CollectionService.swift
//  FakeNFT
//
//  Created by Денис Максимов on 11.04.2025.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias OrdersCompletion = (Result<Orders, Error>) -> Void

protocol CollectionServiceProtocol {
    func fetchProfile(completion: @escaping ProfileCompletion)
    func fetchOrders(completion: @escaping OrdersCompletion)
    func updateProfile(with likes: [String], completion: @escaping ProfileCompletion)
    func updateOrders(with nfts: [String], completion: @escaping OrdersCompletion)
}

final class CollectionService: CollectionServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileGetRequest()
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }
    
    func fetchOrders(completion: @escaping OrdersCompletion) {
        let request = OrdersGetRequest()
        networkClient.send(request: request, type: Orders.self, onResponse: completion)
    }
    
    func updateProfile(with likes: [String], completion: @escaping ProfileCompletion) {
        let request = LikesPutRequest(likes: likes)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }
    
    func updateOrders(with nfts: [String], completion: @escaping OrdersCompletion) {
        let request = OrdersPutRequest(nfts: nfts)
        networkClient.send(request: request, type: Orders.self, onResponse: completion)
    }
}
