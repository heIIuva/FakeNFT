//
//  NftPutOrderRequest.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 09.04.2025.
//

import Foundation


struct NftPutOrderRequest: NetworkRequest {
    let order: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto? {
        NftPutOrderDto(newNfts: order.isEmpty ? "null" : order.joined(separator: ", "))
    }
}

struct NftPutOrderDto: Dto {
    let orderRequestKey: String = "nfts"
    let newNfts: String
        
    func asDictionary() -> [String : String] {
        [orderRequestKey: newNfts]
    }
}

