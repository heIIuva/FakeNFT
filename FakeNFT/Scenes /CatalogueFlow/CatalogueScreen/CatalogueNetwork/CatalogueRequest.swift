//
//  CatalogueRequest.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

struct CatalogueRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}
