//
//  ContactManager.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/27.
//

import UIKit
import Contacts
import ContactsUI

private struct AssociatedKeys {
    static var singleContactBlock: UInt8 = 0
}

final class ContactManager: NSObject {
    
    static let shared = ContactManager()
    private let store = CNContactStore()
    
    func checkAuthorization(from vc: UIViewController,
                            granted: @escaping () -> Void) {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized, .limited:
            granted()
            
        case .notDetermined:
            store.requestAccess(for: .contacts) { grantedAccess, _ in
                DispatchQueue.main.async {
                    grantedAccess ? granted() : self.showSettingAlert(from: vc)
                }
            }
            
        case .denied, .restricted:
            showSettingAlert(from: vc)
            
        @unknown default:
            break
        }
    }
    
    // MARK: - 弹窗跳转系统设置
    private func showSettingAlert(from vc: UIViewController) {
        let alert = UIAlertController(
            title: "无法访问通讯录",
            message: "请在系统设置中开启通讯录权限",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        vc.present(alert, animated: true)
    }
}

extension ContactManager: CNContactPickerDelegate {
    
    func pickSingleContact(from vc: UIViewController,
                           completion: @escaping ([String: String]) -> Void) {
        
        checkAuthorization(from: vc) {
            let picker = CNContactPickerViewController()
            picker.delegate = self
            picker.displayedPropertyKeys = [
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactPhoneNumbersKey
            ]
            
            objc_setAssociatedObject(
                picker,
                &AssociatedKeys.singleContactBlock,
                completion,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
            
            vc.present(picker, animated: true)
        }
    }
    
    public func contactPicker(_ picker: CNContactPickerViewController,
                              didSelect contact: CNContact) {
        
        let name = contact.familyName + contact.givenName
        
        let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
        
        let result: [String: String] = [
            "waitern": name,
            "sors": phone
        ]
        
        if let block = objc_getAssociatedObject(
            picker,
            &AssociatedKeys.singleContactBlock
        ) as? ([String: String]) -> Void {
            block(result)
        }
    }
}

extension ContactManager {
    
    func fetchAllContacts(from vc: UIViewController,
                          completion: @escaping ([[String: String]]) -> Void) {
        
        checkAuthorization(from: vc) {
            
            var results: [[String: String]] = []
            
            let keys: [CNKeyDescriptor] = [
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor
            ]
            
            let request = CNContactFetchRequest(keysToFetch: keys)
            
            do {
                try self.store.enumerateContacts(with: request) { contact, _ in
                    
                    let name = contact.familyName + contact.givenName
                    let phones = contact.phoneNumbers
                        .map { $0.value.stringValue }
                        .joined(separator: ",")
                    
                    guard !phones.isEmpty else { return }
                    
                    results.append([
                        "waitern": name,
                        "sors": phones
                    ])
                }
                
                completion(results)
                
            } catch {
                completion([])
            }
        }
    }
}

