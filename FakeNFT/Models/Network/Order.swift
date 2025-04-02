//
//  Order.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 02.04.2025.
//

import Foundation


struct Order: Codable {
    let id: String
    let nfts: [String]
}
