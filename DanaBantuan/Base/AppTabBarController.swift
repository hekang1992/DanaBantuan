//
//  AppTabBarController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    // 颜色定义
    private let selectedTextColor: UIColor = UIColor(hex: "#0A1121")
    private let normalTextColor: UIColor = UIColor(hex: "#759199")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
        customizeTabBarAppearance()
    }
    
    private func setupTabBar() {
        tabBar.isTranslucent = false
        tabBar.tintColor = selectedTextColor
        tabBar.unselectedItemTintColor = normalTextColor
    }
    
    private func setupViewControllers() {
        let homeVC = HomeViewController()
        let orderVC = OrderViewController()
        let centerVC = CenterViewController()
        
        homeVC.tabBarItem = UITabBarItem(
            title: LanguageManager.localizedString(for: "Home"),
            image: UIImage(named: "tab_home_nor_image")?
                .withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tab_home_sel_image")?
                .withRenderingMode(.alwaysOriginal)
        )
        
        orderVC.tabBarItem = UITabBarItem(
            title: LanguageManager.localizedString(for: "Order"),
            image: UIImage(named: "tab_list_nor_image")?
                .withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tab_list_sel_image")?
                .withRenderingMode(.alwaysOriginal)
        )
        
        centerVC.tabBarItem = UITabBarItem(
            title: LanguageManager.localizedString(for: "My"),
            image: UIImage(named: "tab_mine_nor_image")?
                .withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tab_mine_sel_image")?
                .withRenderingMode(.alwaysOriginal)
        )
        
        let homeNav = AppNavigationController(rootViewController: homeVC)
        let orderNav = AppNavigationController(rootViewController: orderVC)
        let centerNav = AppNavigationController(rootViewController: centerVC)
        
        viewControllers = [homeNav, orderNav, centerNav]
        
        selectedIndex = 0
        
    }
    
    private func customizeTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: selectedTextColor,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: normalTextColor,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            UITabBarItem.appearance().setTitleTextAttributes([
                .foregroundColor: normalTextColor,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ], for: .normal)
            
            UITabBarItem.appearance().setTitleTextAttributes([
                .foregroundColor: selectedTextColor,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ], for: .selected)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animateTabBarItem(item)
    }
    
    private func animateTabBarItem(_ item: UITabBarItem) {
        guard let view = item.value(forKey: "view") as? UIView else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.25, animations: {
                view.transform = .identity
            })
        }
    }
}
