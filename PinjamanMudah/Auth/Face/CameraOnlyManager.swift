//
//  CameraOnlyManager.swift
//  PinjamanMudah
//
//  Created by Thomas Brown on 2025/12/27.
//

import UIKit
import AVFoundation

class CameraOnlyManager: NSObject {
    
    enum CameraPosition {
        case front
        case back
    }
    
    private var completion: ((UIImage) -> Void)?
    private weak var fromVC: UIViewController?
    
    func openCamera(from vc: UIViewController,
                    position: CameraPosition,
                    completion: @escaping (UIImage) -> Void) {
        
        self.fromVC = vc
        self.completion = completion
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            self.presentCamera(position: position)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.presentCamera(position: position)
                    : self.showSettingAlert()
                }
            }
            
        case .denied, .restricted:
            self.showSettingAlert()
            
        @unknown default:
            break
        }
    }
    
    private func presentCamera(position: CameraPosition) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera),
              let vc = fromVC else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        picker.cameraDevice = (position == .front) ? .front : .rear
        
        vc.present(picker, animated: true) {
            if position == .front {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                    self?.hidePickerView(pickerView: picker.view)
                }
            }
        }
    }
    
    private func showSettingAlert() {
        guard let vc = fromVC else { return }
        
        let alert = UIAlertController(
            title: LanguageManager.localizedString(for: "Camera Permission"),
            message: LanguageManager.localizedString(for: "NSCameraUsageDescription"),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Cancel"), style: .cancel))
        alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Go to Settings"), style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
        vc.present(alert, animated: true)
    }
    
    private func compressImage(_ image: UIImage, maxSizeKB: Int = 800) -> UIImage {
        let maxBytes = maxSizeKB * 1024
        var compression: CGFloat = 0.8
        var data = image.jpegData(compressionQuality: compression)!
        
        while data.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            data = image.jpegData(compressionQuality: compression)!
        }
        
        return UIImage(data: data) ?? image
    }
}

extension CameraOnlyManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            let compressed = compressImage(image)
            completion?(compressed)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func hidePickerView(pickerView: UIView) {
        if #available(iOS 26, *) {
            hideFlipButtonForiOS26AndAbove(in: pickerView)
        } else {
            hideFlipButtonForiOS25AndBelow(in: pickerView)
        }
    }
    
    private func hideFlipButtonForiOS26AndAbove(in view: UIView) {
        guard let targetClass = NSClassFromString("SwiftUI._UIGraphicsView") else {
            return
        }
        
        hideSpecificSubview(in: view, targetClass: targetClass) { subview in
            subview.bounds.width == 48 &&
            subview.bounds.height == 48 &&
            subview.frame.minX > UIScreen.main.bounds.width / 2.0
        }
    }
    
    private func hideFlipButtonForiOS25AndBelow(in view: UIView) {
        hideSpecificSubview(in: view) { subview in
            subview.description.contains("CAMFlipButton")
        }
    }
    
    private func hideSpecificSubview(in view: UIView,
                                     targetClass: AnyClass? = nil,
                                     condition: (UIView) -> Bool) {
        for subview in view.subviews {
            if let targetClass = targetClass {
                if subview.isKind(of: targetClass) && condition(subview) {
                    subview.isHidden = true
                    return
                }
            } else if condition(subview) {
                subview.isHidden = true
                return
            }
            
            hideSpecificSubview(in: subview, targetClass: targetClass, condition: condition)
        }
    }
    
}
