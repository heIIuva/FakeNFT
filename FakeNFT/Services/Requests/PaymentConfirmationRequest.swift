//
//  PaymentConfirmationRequest.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 12.04.2025.
//

import Foundation


struct PaymentConfirmationRequest: NetworkRequest {
    let currency: Currency
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currency.id)")
    }
    var dto: Dto?
}
