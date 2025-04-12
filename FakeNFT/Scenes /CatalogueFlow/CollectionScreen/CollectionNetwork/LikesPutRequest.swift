//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Денис Максимов on 11.04.2025.
//

import Foundation

struct LikesPutRequest: NetworkRequest {
    var likes: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod = HttpMethod.put
    var dto: Encodable?

    init(likes: [String]) {
        self.likes = likes
        var components = URLComponents()
        components.queryItems = likes.map {
            URLQueryItem(name: "likes", value: $0)
        }
        if let queryString = components.percentEncodedQuery {
            dto = queryString
        }
    }
}
