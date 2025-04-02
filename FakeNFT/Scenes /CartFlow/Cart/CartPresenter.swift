//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 01.04.2025.
//

import Foundation


protocol CartPresenterProtocol: AnyObject {
    var viewController: CartVCProtocol? { get set }
    
    var nfts: [Nft] { get }
    var totalPrice: Float { get }
    var totalAmount: Int { get }
    func calculateCart()
    func fetchOrder()
}


final class CartPresenter: CartPresenterProtocol {
    
    // MARK: - init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - properties
    
    weak var viewController: CartVCProtocol?
    private let servicesAssembly: ServicesAssembly
        
    private(set) var nfts: [Nft] = []
    
    private(set) var totalPrice: Float = 0.0
    private(set) var totalAmount: Int = 0
    
    private var isLoading: Bool = false
    
    // MARK: - protocol methods
    
    func calculateCart() {
        if !nfts.isEmpty {
            totalAmount = nfts.count
            totalPrice = 0
            nfts.forEach { totalPrice += $0.price }
            viewController?.cartNonEmpty()
        }
    }
    
    func fetchOrder() {
        if !isLoading {
            isLoading = true
            servicesAssembly.nftService.loadOrder { [weak self] (result: Result<Order, Error>) in
                guard let self else { return }
                switch result {
                case .success(let order):
                    fetchNfts(ids: order.nfts)
                case .failure(let error):
                    print(error)
                }
                viewController?.cartNonEmpty()
                isLoading = false
            }
        }
    }
    
    // MARK: - private methods
        
    private func fetchNfts(ids: [String]) {
        for id in ids {
            servicesAssembly.nftService.loadNft(id: id) { [weak self] (result: Result<Nft, Error>) in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    if !self.nfts.contains(where: { $0.id == nft.id }) {
                        self.nfts.append(nft)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
