//
//  CataloguePresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

protocol CataloguePresenterProtocol: AnyObject {
    var collections: [NftCollection] { get }
    func loadCatalogue()
    func setupCatalogueView(_ view: CatalogueViewProtocol)
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell
}

final class CataloguePresenter: CataloguePresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: CatalogueViewProtocol?
    private let catalogueService = CatalogueService(networkClient: DefaultNetworkClient())
    private(set) var collections: [NftCollection] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    // MARK: - Methods
    
    func setupCatalogueView(_ view: CatalogueViewProtocol) {
        self.view = view
    }
    
    func loadCatalogue() {
        view?.showIndicator()
        catalogueService.fetchCatalogue { [weak self] result in
            switch result {
            case .success(let collections):
                self?.collections = collections
                self?.view?.hideIndicator()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell {
        cell.configure(
            image: collections[indexPath.row].cover,
            title: collections[indexPath.row].name,
            count: collections[indexPath.row].nfts.count)
        return cell
    }
}
