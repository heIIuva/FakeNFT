//
//  OrdersGetRequest.swift
//  FakeNFT
//
//  Created by Денис Максимов on 12.04.2025.
//

import Foundation

struct OrdersGetRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
