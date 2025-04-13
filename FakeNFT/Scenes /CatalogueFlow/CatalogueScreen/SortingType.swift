//
//  SortingTypeStorage.swift
//  FakeNFT
//
//  Created by Денис Максимов on 13.04.2025.
//

import Foundation

enum SortingType: Codable {
    case none
    case byName
    case byCount
    
    static private let storageKey = "SortingType"
    
    static func saveSortingType(_ sortingType: SortingType) {
        do {
            let encodedData = try JSONEncoder().encode(sortingType)
            UserDefaults.standard.set(encodedData, forKey: SortingType.storageKey)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    static func getSortingType() -> SortingType {
        guard let savedData = UserDefaults.standard.data(forKey: SortingType.storageKey) else {
            return .none
        }
        do {
            let sortingType = try JSONDecoder().decode(SortingType.self, from: savedData)
            return sortingType
        } catch {
            assertionFailure(error.localizedDescription)
            return .none
        }
    }
}
