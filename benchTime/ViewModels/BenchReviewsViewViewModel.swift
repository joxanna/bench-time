//
//  BenchReviewsViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 1/7/2024.
//

import SwiftUI
import MapKit
import SwiftOverpassAPI

class BenchReviewsViewViewModel: ObservableObject {
    @Published var addressText: String = "No address"
    @Published var benchReviews: [ReviewModel]?
    @Published var errorMessage: String?
    @Published var averageRating: Double = 0.0
    @Published var ratingText: String = ""
    
    func fetchReviews(id: String) {
        print("Fetching...")
        DatabaseAPI.shared.readReviewsByBench(benchId: id) { reviews, error in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            } else if let reviews = reviews {
                self.benchReviews = reviews
            }
        }
    }
    
    func getAverageRating() {
        guard let reviews = benchReviews, !reviews.isEmpty else {
            return
        }
        
        var total: Double = 0
        for review in reviews {
            total += review.rating
        }
        
        self.averageRating = total / Double(reviews.count)
        
        if averageRating.truncatingRemainder(dividingBy: 1) == 0 {
            // Rating is a whole number, display it as an integer
            self.ratingText = String(format: "(%.0f/5 stars)", averageRating)
        } else {
            // Rating has a decimal part, display it with one decimal place
            self.ratingText = String(format: "(%.1f/5 stars)", averageRating)
        }
    }

    
    func getBenchAddress(latitude: Double, longitude: Double) {
        getAddress(latitude: latitude, longitude: longitude) { result, error in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
            else if let result = result {
                self.addressText = result
            }
        }
    }
}
