//
//  GlobalFunctions.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//

import Foundation
import SwiftUI
import CoreLocation

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func compareReviewsByDate(review1: ReviewModel, review2: ReviewModel) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date1 = dateFormatter.date(from: review1.createdTimestamp),
          let date2 = dateFormatter.date(from: review2.createdTimestamp) else {
        return false
    }
    return date1 > date2
}

func convertLatAndLongToAddress(latitude: Double, longitude: Double, completion: @escaping (String?, Error?) -> Void) {
    let location = CLLocation(latitude: latitude, longitude: longitude)
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        guard error == nil else {
            print("Reverse geocoding error: \(error!.localizedDescription)")
            completion(nil, error)
            return
        }
        
        if let placemark = placemarks?.first {
            // Here you can access various properties of the placemark such as address components
            var addressComponents = [String]()
                        
            if let name = placemark.name, !name.isEmpty {
                addressComponents.append(name)
            }
            if let locality = placemark.locality, !locality.isEmpty {
                addressComponents.append(locality)
            }
            if let administrativeArea = placemark.administrativeArea, !administrativeArea.isEmpty {
                addressComponents.append(administrativeArea)
            }
            if let country = placemark.country, !country.isEmpty {
                addressComponents.append(country)
            }
            
            let address = addressComponents.joined(separator: ", ")

//            print("Reverse geocoded address: \(address)")
            completion(address, nil)
        } else {
            print("No placemarks found.")
            completion(nil, NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "No placemarks found"]))
        }
    }
}

func getAddress(latitude: Double, longitude: Double, completion: @escaping (String?, Error?) -> Void) {
    convertLatAndLongToAddress(latitude: latitude, longitude: longitude) { result, error in
        if let error = error {
            completion(nil, error)
        }
        else if let result = result {
            completion(result, nil)
        } else {
            let latitude = "\(latitude)"
            let longitude = "\(longitude)"
            let address = "Latitude: \(latitude), Longitude: \(longitude)"
            completion(address, nil)
        }
    }
}
