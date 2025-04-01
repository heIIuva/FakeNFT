import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(systemName: "cart"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartPresenter = CartPresenter()
        let cartController = CartViewController(servicesAssembly: servicesAssembly, presenter: cartPresenter)
        cartController.tabBarItem = cartTabBarItem
        let cartNavController = UINavigationController(rootViewController: cartController)

        viewControllers = [catalogController, cartNavController]

        view.backgroundColor = .systemBackground
    }
}
