//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 04.04.2025.
//

protocol MyNftView: AnyObject {
    func display(nfts: [Nft])
}

enum NftSortOption {
    case name
    case price
    case rating
}


final class MyNftPresenter {
    weak var view: MyNftView?
    private var nfts: [Nft] = []

    init(view: MyNftView) {
        self.view = view
    }

    func viewDidLoad() {
        nfts = Nft.mockData
        view?.display(nfts: nfts)
    }

    func sort(by option: NftSortOption) {
        switch option {
        case .name:
            nfts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .price:
            nfts.sort { $0.price < $1.price }
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        }
        view?.display(nfts: nfts)
    }
}
