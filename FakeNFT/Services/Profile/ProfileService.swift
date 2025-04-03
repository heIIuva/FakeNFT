//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 28.03.2025.
//
import Foundation

protocol ProfileService {
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void)
    func updateProfile(
        name: String,
        avatar: String,
        description: String,
        website: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    )
}
