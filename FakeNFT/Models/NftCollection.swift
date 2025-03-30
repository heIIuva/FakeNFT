//
//  NftCollection.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

struct NftCollection: Codable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
