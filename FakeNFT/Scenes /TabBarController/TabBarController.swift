import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "profile_no_active")?.withRenderingMode(.alwaysOriginal),
        selectedImage: UIImage(named: "profile_active")?.withRenderingMode(.alwaysOriginal)
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTabBarItem.tag = 0
        
        let profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
        let profileNavController = CustomNavigationController(rootViewController: profileViewController)
        profileNavController.tabBarItem = profileTabBarItem

        let catalogController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [profileNavController, catalogController]
        view.backgroundColor = .systemBackground
    }
}
