//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Alexander Bralnin on 04.04.2025.
//

protocol MyNftView: AnyObject {
    func display(nfts: [Nft])
}

final class MyNftPresenter {
    weak var view: MyNftView?

    init(view: MyNftView) {
        self.view = view
    }

    func viewDidLoad() {
        let mockNFTs = Nft.mockData
        view?.display(nfts: mockNFTs)
    }
}
