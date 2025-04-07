//
//  PaymentPresenter.swift
//  FakeNFT
//
//  Created by Malyshev Roman on 07.04.2025.
//

import Foundation


protocol PaymentPresenterProtocol: AnyObject {
    var viewController: PaymentVCProtocol? { get set }
    
    var currencies: [Currency] { get }
    var selectedCurrency: Currency? { get set }
    var selectedCurrencyIndex: IndexPath? { get set }
    
    func fetchCurrencies(completion: @escaping () -> Void)
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
    
    func fetchCurrencies(completion: @escaping () -> Void) {
        servicesAssembly.nftService.loadCurrencies { [weak self] (result: Result<[Currency], Error>) in
            guard let self else { return }
            switch result {
            case .success(let currencies):
                self.currencies = currencies
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
