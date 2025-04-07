//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 04.04.2025.
//
import Foundation

protocol MyNftView: AnyObject {
    func reloadData()
}

enum NftSortOption {
    case name
    case price
    case rating
}

final class MyNftPresenter {
    private weak var view: MyNftView?
    private let nftService: NftService
    private let nftIDs: [String]
    private var nfts: [Nft] = []

    init(view: MyNftView, nftService: NftService, nftIDs: [String]) {
        self.view = view
        self.nftService = nftService
        self.nftIDs = nftIDs
    }

    func viewDidLoad() {
        guard !nftIDs.isEmpty else { return }
        UIBlockingProgressHUD.show()
        loadNextNft(at: 0)
    }

    private func loadNextNft(at index: Int) {
        guard index < nftIDs.count else {
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                self.view?.reloadData()
            }
            return
        }

        let id = nftIDs[index]
        nftService.loadNft(id: id) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                case .failure(let error):
                    print("Failed to load NFT with id \(id):", error)
                }

                self.loadNextNft(at: index + 1)
            }
        }
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
        view?.reloadData()
    }

    var numberOfItems: Int {
        return nfts.count
    }

    func item(at index: Int) -> Nft {
        return nfts[index]
    }
}
