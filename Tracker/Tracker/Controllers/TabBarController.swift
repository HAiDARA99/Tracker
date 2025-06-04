import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarAppearance()
    }
    
    private func setupTabBar() {
        let trackerVC = UINavigationController(rootViewController: TrackersViewController())
        let statsVC = StatsViewController()
        
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TabBarTracker"),
            selectedImage: nil)
        
        statsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "TabBarStats"),
            selectedImage: nil)
        
        viewControllers = [trackerVC, statsVC]
    }
    
    private func setupTabBarAppearance() {
        view.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = .blue
        tabBar.unselectedItemTintColor = .lightGrey
        
        tabBar.layer.shadowColor = UIColor.systemGray4.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 0
    }
}
