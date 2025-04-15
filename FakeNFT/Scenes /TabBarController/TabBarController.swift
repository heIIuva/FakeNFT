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

    private let profileTabBarItem = UITabBarItem(
        title: Localizable.tabProfile,
        image: UIImage(named: "profile_no_active")?.withRenderingMode(.alwaysTemplate),
        selectedImage: UIImage(named: "profile_active")?.withRenderingMode(.alwaysTemplate)
    )

    private let catalogTabBarItem = UITabBarItem(
        title: Localizable.tabCatalog,
        image: UIImage(systemName: "square.stack.3d.up.fill")?.withRenderingMode(.alwaysTemplate),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: Localizable.tabCart,
        image: UIImage(resource: .cartTabBarItem),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background

        profileTabBarItem.tag = 0

        setupTabs()
        applyTabBarThemeColors()
    }

    private func setupTabs() {
        let profileVC = ProfileViewController(servicesAssembly: servicesAssembly)
        let profileNavController = CustomNavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = profileTabBarItem

        let catalogVC = TestCatalogViewController(servicesAssembly: servicesAssembly)
        catalogVC.tabBarItem = catalogTabBarItem
        
        let cartPresenter = CartPresenter(servicesAssembly: servicesAssembly)
        let cartController = CartViewController(presenter: cartPresenter)
        cartController.tabBarItem = cartTabBarItem
        let cartNavController = UINavigationController(rootViewController: cartController)

        viewControllers = [profileNavController, catalogVC, cartNavController]
    }

    private func applyTabBarThemeColors() {
        tabBar.tintColor = .tabBarActive
        tabBar.unselectedItemTintColor = .tabBarInactive
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            applyTabBarThemeColors()
        }
    }
}
