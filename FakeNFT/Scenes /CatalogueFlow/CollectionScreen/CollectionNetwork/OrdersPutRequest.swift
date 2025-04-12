//
//  OrdersPutRequest.swift
//  FakeNFT
//
//  Created by Денис Максимов on 12.04.2025.
//

import Foundation

struct OrdersPutRequest: NetworkRequest {
    var nfts: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod = HttpMethod.put
    var dto: Encodable?
    
    init(nfts: [String]) {
        self.nfts = nfts
        var components = URLComponents()
        components.queryItems = nfts.map {
            URLQueryItem(name: "nfts", value: $0)
        }
        if let queryString = components.percentEncodedQuery {
            dto = queryString
        }
    }
}
