//
//  CurrentLocation.swift
//  O'Romeo
//
//  Created by Lo Howard on 6/26/19.
//  Copyright © 2019 Brian Daniel. All rights reserved.
//

import UIKit
import CoreLocation

protocol CurrentLocationDelegate: class {
    func locationWasUpdated(location: CLLocation)
}

class CurrentLocation: NSObject {
    
    static let shared = CurrentLocation()
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
//    let placemarks: CLPlacemark?
    var location: CLLocation?
    var isUpdatingLocation = false
    weak var delegate: CurrentLocationDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }
    }
    
    func getCityName(location: CLLocation, completion: @escaping (String?) -> Void) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("City name \(error.localizedDescription)")
                completion(nil)
            }

            guard let placemarks = placemarks else { return }
            let cityName = placemarks.first?.locality
            completion(cityName)
        }
    }
    
//    func getCityName(from placemark: CLPlacemark) -> String {
//        guard let placemark = placemark else { return }
//        let city = placemark.locality
//        return String(city)
//    }
    
    func findLocation() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            break
        default:
            break
        }
    }
}

extension CurrentLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.locationWasUpdated(location: location)
    }
}
