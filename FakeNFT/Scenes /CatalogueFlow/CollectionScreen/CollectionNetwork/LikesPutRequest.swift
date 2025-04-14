//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Денис Максимов on 11.04.2025.
//

import Foundation

struct LikesPutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod = HttpMethod.put
    var dto: Dto?

    init(likes: [String]) {
        self.dto = LikesPutRequestDto(likes: likes)
    }
}

struct LikesPutRequestDto: Dto {
    let likes: [String]
    let likesKey = "likes"
    
    func asDictionary() -> [String : String] {
        [likesKey: likes.isEmpty ? "null" : likes.joined(separator: ", ")]
    }
}
