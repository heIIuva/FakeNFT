import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(resource: .tabProfile),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(resource: .tabCatalogue),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(resource: .tabCart),
        tag: 2
    )
    
    private let statTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.stat", comment: ""),
        image: UIImage(resource: .tabStat),
        tag: 3
    )
    
    // MARK: - Methods of lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            setupProfileViewController(),
            setupCatalogueViewController(),
            setupCartViewController(),
            setupStatViewController()
        ]
        selectedIndex = 1
        let appearance = tabBar.standardAppearance
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .nftBlack)]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(resource: .nftBlack)
        tabBar.standardAppearance = appearance
    }
    
    // MARK: - Methods
    
    private func setupProfileViewController() -> UIViewController {
        let profileViewController = UIViewController()
        profileViewController.tabBarItem = profileTabBarItem
        return profileViewController
    }
    
    private func setupCatalogueViewController() -> UIViewController {
        let cataloguePresenter = CataloguePresenter()
        let catalogueViewController = CatalogueViewController(presenter: cataloguePresenter)
        cataloguePresenter.setupCatalogueView(catalogueViewController)
        cataloguePresenter.setupCatalogueService(CatalogueService())
        catalogueViewController.tabBarItem = catalogTabBarItem
        return catalogueViewController
    }
    
    private func setupCartViewController() -> UIViewController {
        let profileViewController = UIViewController()
        profileViewController.tabBarItem = cartTabBarItem
        return profileViewController
    }
    
    private func setupStatViewController() -> UIViewController {
        let profileViewController = UIViewController()
        profileViewController.tabBarItem = statTabBarItem
        return profileViewController
    }
}
