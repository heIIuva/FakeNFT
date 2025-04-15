//
//  CataloguePresenter.swift
//  FakeNFT
//
//  Created by Денис Максимов on 28.03.2025.
//

import Foundation

protocol CataloguePresenterProtocol: AnyObject {
    func loadCatalogue(withIndicator: Bool)
    func getCollectionsCount() -> Int
    func getCollectionPresenter(for indexPath: IndexPath) -> CollectionPresenterProtocol
    func setupCatalogueView(_ view: CatalogueViewProtocol)
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell
    func setSortingType(_ sortingType: SortingType)
}

final class CataloguePresenter: CataloguePresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: CatalogueViewProtocol?
    private let servicesAssembly: ServicesAssembly
    private var sortingType: SortingType {
        didSet {
            SortingType.saveSortingType(sortingType)
        }
    }
    private var catalogue: [NftCollection] = [] {
        didSet {
            view?.reloadData()
        }
    }
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.sortingType = SortingType.getSortingType()
    }
    
    // MARK: - Methods
    
    func setupCatalogueView(_ view: CatalogueViewProtocol) {
        self.view = view
    }
    
    func loadCatalogue(withIndicator: Bool) {
        view?.shouldShowIndicator(withIndicator ? true : false)
        servicesAssembly.catalogueService.fetchCatalogue { [weak self] result in
            guard let self else { return }
            view?.shouldShowIndicator(false)
            switch result {
            case .success(let collections):
                catalogue = collections
            case .failure(_):
                let errorModel = ErrorModel(
                    message: Localizable.errorDataLost,
                    actionText: Localizable.errorRepeat,
                    action: { [weak self] in self?.loadCatalogue(withIndicator: withIndicator) })
                view?.showErrorWithCancel(errorModel)
            }
        }
    }
    
    func getCollectionsCount() -> Int {
        getSortedCatalogue().count
    }
    
    func getCollectionPresenter(for indexPath: IndexPath) -> CollectionPresenterProtocol {
        CollectionPresenter(collection: getSortedCatalogue()[indexPath.row], servicesAssembly: servicesAssembly)
    }
    
    func configure(cell: CatalogueTableViewCell, for indexPath: IndexPath) -> CatalogueTableViewCell {
        cell.configure(
            image: getSortedCatalogue()[indexPath.row].cover,
            title: getSortedCatalogue()[indexPath.row].name,
            count: getSortedCatalogue()[indexPath.row].nfts.count)
        return cell
    }
    
    func setSortingType(_ sortingType: SortingType) {
        self.sortingType = sortingType
        view?.reloadData()
    }
    
    private func getSortedCatalogue() -> [NftCollection] {
        switch sortingType {
        case .byName:
            return catalogue.sorted { $0.name < $1.name }
        case .byCount:
            return catalogue.sorted { $0.nfts.count > $1.nfts.count }
        case .none:
            return catalogue
        }
    }
}
