//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 28.03.2025.
//
import Foundation

protocol ProfileService {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        // Заглушка с мок-данными
        let profile = Profile(
            id: UUID(uuidString: "b899cba7-6d68-4e17-81d7-03a369ab7a7c") ?? UUID(),
            name: "Edwin Hodges",
            avatar: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/767.jpg",
            description: nil,
            website: "https://practicum.yandex.ru/algorithms-interview/",
            nfts: [],
            likes: []
        )
        completion(.success(profile))
    }
}
