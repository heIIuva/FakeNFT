//
//  OrdersPutRequest.swift
//  FakeNFT
//
//  Created by Денис Максимов on 12.04.2025.
//

import Foundation

struct OrdersPutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod = HttpMethod.put
    var dto: Dto?
    
    init(nfts: [String]) {
        self.dto = OrdersPutRequestDto(nfts: nfts)
    }
}

struct OrdersPutRequestDto: Dto {
    let nfts: [String]
    let nftsKey = "nfts"
    
    func asDictionary() -> [String : String] {
        [nftsKey: nfts.isEmpty ? "null" : nfts.joined(separator: ", ")]
    }
}
