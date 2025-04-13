//
//  CataloguePresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

protocol CataloguePresenterProtocol: AnyObject {
    func loadCatalogue()
    func getCollectionsCount() -> Int
    func getCollectionPresenter(for indexPath: IndexPath) -> CollectionPresenterProtocol
    func setupCatalogueView(_ view: CatalogueViewProtocol)
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell
    func sortCatalogue(by type: SortingType)
}

enum SortingType {
    case byName
    case byCount
}

final class CataloguePresenter: CataloguePresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: CatalogueViewProtocol?
    private let servicesAssembly: ServicesAssembly
    private var catalogue: [NftCollection] = [] {
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
        view?.shouldShowIndicator(true)
        servicesAssembly.catalogueService.fetchCatalogue { [weak self] result in
            guard let self else { return }
            view?.shouldShowIndicator(false)
            switch result {
            case .success(let collections):
                catalogue = collections
            case .failure(_):
                let errorModel = ErrorModel(
                    message: NSLocalizedString("Error.title", comment: ""),
                    actionText: NSLocalizedString("Error.repeat", comment: ""),
                    action: loadCatalogue)
                view?.showErrorWithCancel(errorModel)
            }
        }
    }
    
    func getCollectionsCount() -> Int {
        catalogue.count
    }
    
    func getCollectionPresenter(for indexPath: IndexPath) -> CollectionPresenterProtocol {
        CollectionPresenter(collection: catalogue[indexPath.row], servicesAssembly: servicesAssembly)
    }
    
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell {
        cell.configure(
            image: catalogue[indexPath.row].cover,
            title: catalogue[indexPath.row].name,
            count: catalogue[indexPath.row].nfts.count)
        return cell
    }
    
    func sortCatalogue(by type: SortingType) {
        switch type {
        case .byName:
            catalogue.sort { $0.name < $1.name }
        case .byCount:
            catalogue.sort { $0.nfts.count > $1.nfts.count }
        }
    }
}
