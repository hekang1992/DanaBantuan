//
//  LoadingView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/25.
//

import UIKit
import SnapKit
import Toast_Swift

final class LoadingView {
    
    static let shared = LoadingView()
    
    private var maskView: UIView?
    private var containerView: UIView?
    private var indicator: UIActivityIndicatorView?
    
    private init() {}
    
    // MARK: - Show
    func show() {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: { $0.isKeyWindow }) else {
            return
        }
        
        if maskView != nil { return }
        
        let mask = UIView()
        mask.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        mask.isUserInteractionEnabled = true
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .black
        indicator.startAnimating()
        
        window.addSubview(mask)
        mask.addSubview(container)
        container.addSubview(indicator)
        
        mask.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.maskView = mask
        self.containerView = container
        self.indicator = indicator
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.indicator?.stopAnimating()
            self.maskView?.removeFromSuperview()
            
            self.indicator = nil
            self.containerView = nil
            self.maskView = nil
        }
    }
}

class ToastManager {
    static func showMessage(message: String) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.makeToast(message, duration: 3.0, position: .center)
    }
}

