//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 27.03.2025.
//
import Foundation

struct Profile: Decodable {
    let id: UUID
    let name: String
    let avatar: String
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
}
