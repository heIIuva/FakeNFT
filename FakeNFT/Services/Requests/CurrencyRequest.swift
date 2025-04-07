//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 07.04.2025.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    var dto: (any Dto)?
    
    var headers: [String: String]? = ["X-Practicum-Mobile-Token": RequestConstants.token]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
