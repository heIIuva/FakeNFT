//
//  CartPresenter.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 01.04.2025.
//

import Foundation


protocol CartPresenterProtocol: AnyObject {
    var viewController: CartVCProtocol? { get set }
    var servicesAssembly: ServicesAssembly { get }
    
    var nfts: [Nft] { get }
    
    func fetchOrder()
    func sortCart(with option: CartSortOption)
}


final class CartPresenter: CartPresenterProtocol {
    
    // MARK: - init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - properties
    
    weak var viewController: CartVCProtocol?
    private(set) var servicesAssembly: ServicesAssembly
    
    private(set) var nfts: [Nft] = []
    
    private var order: Order?
    
    private var totalPrice: Float = 0.0
    private var totalAmount: Int = 0
    
    private var isLoading: Bool = false
    
    // MARK: - protocol methods
    
    func sortCart(with option: CartSortOption) {
        switch option {
        case .byPrice:
            nfts.sort(by: { $0.price > $1.price })
        case .byRating:
            nfts.sort(by: { $0.rating > $1.rating })
        case .byName:
            nfts.sort(by: { $0.name > $1.name })
        }
        viewController?.updateUI(price: totalPrice, amount: totalAmount)
    }
    
    func fetchOrder() {
        UIBlockingProgressHUD.show()
        servicesAssembly.nftService.loadOrder { [weak self] (result: Result<Order, Error>) in
            guard let self else { return }
            switch result {
            case .success(let order):
                self.order = order
                if !order.nfts.isEmpty {
                    fetchNfts(ids: order.nfts) {
                        self.viewController?.updateUI(price: self.totalPrice, amount: self.totalAmount)
                        self.viewController?.cartNonEmpty()
                    }
                } else {
                    self.viewController?.cartIsEmpty()
                }
            case .failure:
                self.viewController?.cartIsEmpty()
            }
            viewController?.endRefreshing()
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    // MARK: - private methods
    
    private func calculateCart() {
        guard !nfts.isEmpty else { return }
        
        totalAmount = nfts.count
        totalPrice = 0
        nfts.forEach { totalPrice += $0.price }
    }
        
    private func fetchNfts(ids: [String], completion: @escaping () -> Void) {
        for id in ids {
            servicesAssembly.nftService.loadNft(id: id) { [weak self] (result: Result<Nft, Error>) in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    if !self.nfts.contains(where: { $0.id == nft.id }) {
                        self.nfts.append(nft)
                    }
                    calculateCart()
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
