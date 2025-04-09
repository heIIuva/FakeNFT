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
        NftPutOrderDto(param2: order.isEmpty ? "null" : order.joined(separator: ", "))
    }
}

struct NftPutOrderDto: Dto {
    let param1: String = "nfts"
    let param2: String
        
    func asDictionary() -> [String : String] {
        [param1: param2]
    }
}

