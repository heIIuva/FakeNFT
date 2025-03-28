import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [setupCatalogueViewController()]

        view.backgroundColor = .systemBackground
    }
    
    private func setupCatalogueViewController() -> UIViewController {
        let cataloguePresenter = CataloguePresenter()
        let catalogueViewController = CatalogueViewController(presenter: cataloguePresenter)
        cataloguePresenter.setupCatalogueView(catalogueViewController)
        let catalogueNavController = UINavigationController(rootViewController: catalogueViewController)
        catalogueNavController.tabBarItem = catalogTabBarItem
        return catalogueNavController
    }
}
