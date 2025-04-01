//
//  CataloguePresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

protocol CataloguePresenterProtocol: AnyObject {
    var catalogue: [NftCollection] { get }
    var servicesAssembly: ServicesAssembly { get }
    func loadCatalogue()
    func setupCatalogueView(_ view: CatalogueViewProtocol)
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell
}

final class CataloguePresenter: CataloguePresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: CatalogueViewProtocol?
    private(set) var servicesAssembly: ServicesAssembly
    private(set) var catalogue: [NftCollection] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Methods
    
    func setupCatalogueView(_ view: CatalogueViewProtocol) {
        self.view = view
    }
    
    func loadCatalogue() {
        guard let view else { return }
        view.shouldShowIndicator(true)
        servicesAssembly.catalogueService.fetchCatalogue { [weak self] result in
            view.shouldShowIndicator(false)
            guard let self else { return }
            switch result {
            case .success(let collections):
                catalogue = collections
            case .failure(_):
                let errorModel = ErrorModel(
                    message: NSLocalizedString("Error.title", comment: ""),
                    actionText: NSLocalizedString("Error.repeat", comment: ""),
                    action: loadCatalogue)
                view.showErrorWithCancel(errorModel)
            }
        }
    }
    
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell {
        cell.configure(
            image: catalogue[indexPath.row].cover,
            title: catalogue[indexPath.row].name,
            count: catalogue[indexPath.row].nfts.count)
        return cell
    }
}
