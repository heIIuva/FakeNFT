//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 07.04.2025.
//

import UIKit


protocol PaymentPresenterProtocol: AnyObject {
    var viewController: PaymentVCProtocol? { get set }
    
    var currencies: [Currency] { get }
    var selectedCurrency: Currency? { get set }
    var selectedCurrencyIndex: IndexPath? { get set }
    
    func fetchCurrencies(completion: @escaping () -> ())
    func confirmPayment()
}


final class PaymentPresenter: PaymentPresenterProtocol {
    
    // MARK: - init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - properties
    
    weak var viewController: PaymentVCProtocol?
    private let servicesAssembly: ServicesAssembly
    
    private(set) var currencies: [Currency] = []
    
    var selectedCurrency: Currency?
    var selectedCurrencyIndex: IndexPath?
    
    // MARK: - protocol methods
    
    func fetchCurrencies(completion: @escaping () -> ()) {
        servicesAssembly.nftService.loadCurrencies { [weak self] (result: Result<[Currency], Error>) in
            guard let self else { return }
            UIBlockingProgressHUD.show()
            switch result {
            case .success(let currencies):
                self.currencies = currencies
                completion()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func confirmPayment() {
        guard let selectedCurrency else { return }
        servicesAssembly.nftService.confirmPayment(currency: selectedCurrency) { [weak self] (result: Result<Payment, Error>) in
            guard let self else { return }
            UIBlockingProgressHUD.show()
            switch result {
            case .success(let payment):
                if payment.success {
                    cleanCart()
                    viewController?.onPaymentConfirmationResult(message: "", .successful)
                } else {
                    viewController?.onPaymentConfirmationResult(message: Localizable.paymentFail, .failure)
                }
                UIBlockingProgressHUD.dismiss()
            case .failure:
                viewController?.onPaymentConfirmationResult(message: Localizable.connectionLost, .failure)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    // MARK: - private methods
    
    private func cleanCart() {
        servicesAssembly.nftService.updateOrder(nfts: []) { _ in }
    }
}
