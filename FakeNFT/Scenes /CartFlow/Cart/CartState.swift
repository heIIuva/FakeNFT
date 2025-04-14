//
//  CartState.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 12.04.2025.
//

import Foundation


enum CartState {
    case empty
    case nonEmpty
}

extension CartState {
    var isEmpty: Bool {
        self == .empty
    }
}
