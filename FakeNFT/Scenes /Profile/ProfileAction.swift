//
//  ProfileAction.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 07.04.2025.
//
import UIKit

enum ProfileAction: String, CaseIterable {
    case myNFT = "ViewProfile.MyNFT"
    case favorites = "ViewProfile.Favorites"
    case aboutDeveloper = "ViewProfile.AboutDeveloper"

    var localizedTitle: String {
        NSLocalizedString(rawValue, comment: "")
    }

    static func fromLocalizedTitle(_ title: String) -> ProfileAction? {
        allCases.first { $0.localizedTitle == title }
    }

    func count(from profile: Profile) -> Int? {
        switch self {
        case .myNFT: return profile.nfts.count
        case .favorites: return profile.likes.count
        case .aboutDeveloper: return nil
        }
    }

    func makeViewController(profile: Profile, servicesAssembly: ServicesAssembly,  delegate: EditProfileViewControllerDelegate?) -> UIViewController? {
        switch self {
        case .myNFT:
            return MyNftViewController(servicesAssembly: servicesAssembly, nftIDs: profile.nfts)
        case .favorites:
            let vc = FavoritesNftViewController(servicesAssembly: servicesAssembly, nftIDs: profile.likes)
            vc.delegate = delegate
            return vc
        case .aboutDeveloper:
            guard let urlString = profile.website else { return nil }
            return WebViewController(urlString: urlString)
        }
    }
}
