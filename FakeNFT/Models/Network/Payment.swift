//
//  Payment.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 12.04.2025.
//

import Foundation


struct Payment: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}
