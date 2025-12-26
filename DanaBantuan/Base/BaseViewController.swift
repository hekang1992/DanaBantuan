//
//  BaseViewController.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
}

extension BaseViewController {
    
    func changeRootVc() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil
            )
        }
    }
    
}
