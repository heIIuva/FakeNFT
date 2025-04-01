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
}


final class CartPresenter: CartPresenterProtocol {
    
    weak var viewController: CartVCProtocol?
    
    private(set) var nfts: [Nft] = [
        Nft(name: "nigga", id: "1", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png")!], rating: 2, price: 1.78),
        Nft(name: "nigga", id: "1", images: [URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Piper/1.png")!], rating: 2, price: 1.78)
    ]
    
    private(set) var totalPrice: Float = 0.0
    private(set) var totalAmount: Int = 0
    
    func calculateCart() {
        totalAmount = nfts.count
        nfts.forEach { totalPrice += $0.price }
    }

}
