//
//  AppDelegate.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureApplication()
        return true
    }
    
}

extension AppDelegate {
    
    func configureApplication() {
        setupBoard()
        setupMemo()
        setupWindow()
    }
    
    private func setupBoard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    private func setupMemo() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootVc), name: NSNotification.Name("changeRootVc"), object: nil)
    }
    
    private func setupWindow() {
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = StartViewController()
        window?.makeKeyAndVisible()
    }
    
    @objc private func changeRootVc() {
        if UserLoginConfig.isLoggedIn {
            window?.rootViewController = AppTabBarController()
        }else {
            window?.rootViewController = AppNavigationController(rootViewController: LoginViewController())
        }
    }
    
}
