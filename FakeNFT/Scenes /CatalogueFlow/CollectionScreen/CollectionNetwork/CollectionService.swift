//
//  CollectionService.swift
//  FakeNFT
//
//  Created by Денис Максимов on 11.04.2025.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias OrderCompletion = (Result<Order, Error>) -> Void

protocol CollectionServiceProtocol {
    func fetchProfile(completion: @escaping ProfileCompletion)
    func fetchOrders(completion: @escaping OrderCompletion)
    func updateProfile(with likes: [String], completion: @escaping ProfileCompletion)
    func updateOrders(with nfts: [String], completion: @escaping OrderCompletion)
}

final class CollectionService: CollectionServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(completion: @escaping ProfileCompletion) {
        let request = LikesGetRequest()
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }
    
    func fetchOrders(completion: @escaping OrderCompletion) {
        let request = OrdersGetRequest()
        networkClient.send(request: request, type: Order.self, onResponse: completion)
    }
    
    func updateProfile(with likes: [String], completion: @escaping ProfileCompletion) {
        let request = LikesPutRequest(likes: likes)
        networkClient.send(request: request, type: Profile.self, onResponse: completion)
    }
    
    func updateOrders(with nfts: [String], completion: @escaping OrderCompletion) {
        let request = OrdersPutRequest(nfts: nfts)
        networkClient.send(request: request, type: Order.self, onResponse: completion)
    }
}
