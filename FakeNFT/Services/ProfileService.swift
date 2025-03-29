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
    private let profileId: String

    init(networkClient: NetworkClient, profileId: String) {
        self.networkClient = networkClient
        self.profileId = profileId
    }

    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = ProfileGetRequest(profileId: profileId)

        networkClient.send(request: request) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                do {
                    var profile = try JSONDecoder().decode(Profile.self, from: data)

                    if profile.avatar.contains("cloudflare-ipfs.com") {
                        profile = Profile(
                            id: profile.id,
                            name: profile.name,
                            avatar: self.updatedAvatarURL(from: profile.avatar),
                            description: profile.description,
                            website: profile.website,
                            nfts: profile.nfts,
                            likes: profile.likes
                        )
                    }

                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // API response sends depriciated link to image - this os workaround
    #warning("Remove updatedAvatarURL method when API response for Profile will be updated")
    private func updatedAvatarURL(from url: String) -> String {
        url.replacingOccurrences(
            of: "https://cloudflare-ipfs.com/ipfs/",
            with: "https://ipfs.io/ipfs/"
        )
    }
}
