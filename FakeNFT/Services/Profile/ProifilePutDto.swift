//
//  ProifilePutDto.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 30.03.2025.
//

import Foundation

struct ProfilePutDto: Dto {
    let name: String
    let avatar: String
    let description: String
    let website: String

    enum CodingKeys: String, CodingKey {
        case name
        case avatar
        case description
        case website
    }

    func asDictionary() -> [String: String] {
        return [
            CodingKeys.name.rawValue: name,
            CodingKeys.avatar.rawValue: avatar,
            CodingKeys.description.rawValue: description,
            CodingKeys.website.rawValue: website
        ]
    }
}
