//
//  LocationManager.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle authorization status changes
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Handle when location services are authorized
            print("Location services authorized")
        case .denied, .restricted:
            // Handle when location services are denied or restricted
            print("Location services denied or restricted")
        case .notDetermined:
            // Handle when location services authorization status is not determined yet
            print("Location services authorization status not determined")
        @unknown default:
            break
        }
    }
}
