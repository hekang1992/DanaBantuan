//
//  AppTabBarController.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import UIKit
import CoreLocation

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
        self.delegate = self
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let orderVC = OrderViewController()
        let mineVC = CenterViewController()
        
        let homeNav = AppNavigationController(rootViewController: homeVC)
        let orderNav = AppNavigationController(rootViewController: orderVC)
        let mineNav = AppNavigationController(rootViewController: mineVC)
        
        homeNav.tabBarItem = createTabBarItem(
            title: LanguageManager.localizedString(for: "Home"),
            normalImageName: "tab_home_nor_image",
            selectedImageName: "tab_home_sel_image"
        )
        
        orderNav.tabBarItem = createTabBarItem(
            title: LanguageManager.localizedString(for: "Order"),
            normalImageName: "tab_list_nor_image",
            selectedImageName: "tab_list_sel_image"
        )
        
        mineNav.tabBarItem = createTabBarItem(
            title: LanguageManager.localizedString(for: "My"),
            normalImageName: "tab_mine_nor_image",
            selectedImageName: "tab_mine_sel_image"
        )
        
        self.viewControllers = [homeNav, orderNav, mineNav]
        
        self.selectedIndex = 0
    }
    
    private func createTabBarItem(title: String, normalImageName: String, selectedImageName: String) -> UITabBarItem {
        let normalImage = UIImage(named: normalImageName)?
            .withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: selectedImageName)?
            .withRenderingMode(.alwaysOriginal)
        
        let tabBarItem = UITabBarItem(
            title: title,
            image: normalImage,
            selectedImage: selectedImage
        )
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(hex: "#759199"),
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.init(hex: "#0A1121"),
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        tabBarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        return tabBarItem
    }
    
    private func setupTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.init(hex: "#759199")]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.init(hex: "#0A1121")]
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "#759199")],
                for: .normal
            )
            UITabBarItem.appearance().setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "#0A1121")],
                for: .selected
            )
        }
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    }
}

extension AppTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        let status = CLLocationManager().authorizationStatus
        if status != .authorizedAlways && status != .authorizedWhenInUse  {
            self.showSettingAlert()
            return false
        }
        return true
    }
    
    private func showSettingAlert() {
        
        let alert = UIAlertController(
            title: "定位权限未开启",
            message: "请在系统设置中开启定位权限",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        self.present(alert, animated: true)
    }
}
