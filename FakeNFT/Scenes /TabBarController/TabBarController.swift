import UIKit

final class TabBarController: UITabBarController {
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var servicesAssembly: ServicesAssembly

    private let catalogTabBarItem = UITabBarItem(
        title: Localizable.tabCatalog,
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: Localizable.tabCart,
        image: UIImage(resource: .cartTabBarItem),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartPresenter = CartPresenter(servicesAssembly: servicesAssembly)
        let cartController = CartViewController(presenter: cartPresenter)
        cartController.tabBarItem = cartTabBarItem
        let cartNavController = UINavigationController(rootViewController: cartController)

        viewControllers = [catalogController, cartNavController]

        view.backgroundColor = .systemBackground
    }
}
