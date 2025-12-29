//
//  LocationTool.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/29.
//

import UIKit
import CoreLocation

class LocationTool: NSObject {
    
    typealias LocationResultBlock = (_ result: [String: String]?, _ error: Error?) -> Void
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var resultBlock: LocationResultBlock?
    private weak var presentingVC: UIViewController?
    
    init(presentingVC: UIViewController) {
        self.presentingVC = presentingVC
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startLocation(block: @escaping LocationResultBlock) {
        self.resultBlock = block
        checkAuthorizationAndLocate()
    }
    
    private func checkAuthorizationAndLocate() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdating()
            
        case .denied, .restricted:
            callbackDeniedIfNeeded()
            
        @unknown default:
            break
        }
    }
    
    private func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    private func callbackDeniedIfNeeded() {
        resultBlock?(nil, LocationAuthError.denied)
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationTool: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdating()
            
        case .denied, .restricted:
            callbackDeniedIfNeeded()
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                self.resultBlock?(nil, error)
                self.stopUpdating()
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.resultBlock?(nil, NSError(domain: "geocode_failed", code: -1))
                self.stopUpdating()
                return
            }
            
            let dict = self.buildResult(location: location, placemark: placemark)
            self.resultBlock?(dict, nil)
            
            self.stopUpdating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        resultBlock?(nil, error)
        stopUpdating()
    }
}

// MARK: - Data Build
private extension LocationTool {
    
    func buildResult(location: CLLocation, placemark: CLPlacemark) -> [String: String] {
        
        let latitude = "\(location.coordinate.latitude)"
        let longitude = "\(location.coordinate.longitude)"
        
        let countryCode = placemark.isoCountryCode ?? ""
        let country = placemark.country ?? ""
        let province = placemark.administrativeArea ?? ""
        let city = placemark.locality ?? placemark.subAdministrativeArea ?? ""
        let district = placemark.subLocality ?? ""
        let street = placemark.name ?? ""
        
        return [
            "mrish": province,
            "stratous": countryCode,
            "ignfold": country,
            "stagnise": street,
            "rhizeur": latitude,
            "amward": longitude,
            "per": city,
            "osfy": district,
            "bettereer": district
        ]
    }
}

enum LocationAuthError: Error {
    case denied
}

class AppLocationModel {
    static let shared = AppLocationModel()
    private init() {}
    var locationJson: [String: String]?
}

