//
//  SortingTypeStorage.swift
//  FakeNFT
//
//  Created by Денис Максимов on 13.04.2025.
//

import Foundation

enum SortingType: String {
    case none
    case byName
    case byCount
    
    static private let storageKey = "SortingType"
    
    static func saveSortingType(_ sortingType: SortingType) {
        UserDefaults.standard.set(sortingType.rawValue, forKey: SortingType.storageKey)
    }
    
    static func getSortingType() -> SortingType {
        guard let rawType = UserDefaults.standard.string(forKey: SortingType.storageKey),
              let sortingType = SortingType(rawValue: rawType) else {
            return .none
        }
        return sortingType
    }
}
