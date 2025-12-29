//
//  AppNavigationController.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/25.
//

import UIKit

class AppNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        self.navigationBar.isTranslucent = false
        if let gestureRecognizers = view.gestureRecognizers {
            for gesture in gestureRecognizers {
                if let popGesture = gesture as? UIScreenEdgePanGestureRecognizer {
                    view.removeGestureRecognizer(popGesture)
                }
            }
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
