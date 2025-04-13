import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(named: "profile_no_active")?.withRenderingMode(.alwaysTemplate),
        selectedImage: UIImage(named: "profile_active")?.withRenderingMode(.alwaysTemplate)
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill")?.withRenderingMode(.alwaysTemplate),
        tag: 1
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

        viewControllers = [profileNavController, catalogVC]
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
