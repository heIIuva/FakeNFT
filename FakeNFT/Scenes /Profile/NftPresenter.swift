//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 04.04.2025.
//
import Foundation

protocol NftView: AnyObject {
    func reloadData()
}

enum NftSortOption {
    case name
    case price
    case rating
}

final class NftPresenter {
    private weak var view: NftView?
    private let nftService: NftService
    private var nftIDs: [String]
    private var nfts: [Nft] = []

    init(view: NftView, services: ServicesAssembly, nftIDs: [String]) {
        self.view = view
        self.nftService = services.nftService
        self.nftIDs = nftIDs
    }

    func viewDidLoad() {
        reloadNfts()
    }

    func updateNftIDs(_ newIDs: [String]) {
        guard newIDs != nftIDs else { return }
        nftIDs = newIDs
        reloadNfts()
    }

    private func reloadNfts() {
        guard !nftIDs.isEmpty else { return }
        nfts.removeAll()
        view?.reloadData()
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
