import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly
    
    private let profileTabBarItem = UITabBarItem(
        title: Localizable.tabProfile,
        image: UIImage(resource: .tabProfile),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: Localizable.tabCatalog,
        image: UIImage(resource: .tabCatalogue),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: Localizable.tabCart,
        image: UIImage(resource: .tabCart),
        tag: 2
    )
    
    private let statTabBarItem = UITabBarItem(
        title: Localizable.tabStat,
        image: UIImage(resource: .tabStat),
        tag: 3
    )
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        setupAppearance()
    }
    
    // MARK: - Methods
    
    private func setupProfileViewController() -> UIViewController {
        let profileVC = ProfileViewController(servicesAssembly: servicesAssembly)
        let profileNavController = CustomNavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = profileTabBarItem
        return profileNavController
    }
    
    private func setupCatalogueViewController() -> UIViewController {
        let cataloguePresenter = CataloguePresenter(servicesAssembly: servicesAssembly)
        let catalogueViewController = CatalogueViewController(presenter: cataloguePresenter)
        cataloguePresenter.setupCatalogueView(catalogueViewController)
        catalogueViewController.tabBarItem = catalogTabBarItem
        return catalogueViewController
    }
    
    private func setupCartViewController() -> UIViewController {
        let cartPresenter = CartPresenter(servicesAssembly: servicesAssembly)
        let cartController = CartViewController(presenter: cartPresenter)
        cartController.tabBarItem = cartTabBarItem
        let cartNavController = UINavigationController(rootViewController: cartController)
        return cartNavController
    }
    
    private func setupStatViewController() -> UIViewController {
        let profileViewController = UIViewController()
        profileViewController.view.backgroundColor = UIColor(resource: .nftWhite)
        profileViewController.tabBarItem = statTabBarItem
        return profileViewController
    }
    
    private func setupAppearance() {
        let appearance = tabBar.standardAppearance
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .nftBlack)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(resource: .nftBlueUniversal)]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(resource: .nftBlack)
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(resource: .nftBlueUniversal)
        tabBar.standardAppearance = appearance
    }
}
