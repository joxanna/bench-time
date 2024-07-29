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
    @Published var addressText: String = ""
    @Published var benchReviews: [ReviewModel]?
    @Published var showReviews: Bool = false
    @Published var errorMessage: String?
    @Published var averageRating: Double = 0.0
    @Published var ratingText: String = "(0/5 stars)"
    @Published var titleText: String = "0 reviews"
    
    func fetchReviews(id: String) {
        print("Fetching in bench reviews...")
        
        showReviews = false
        
        DatabaseAPI.shared.readReviewsByBench(benchId: id) { reviews, error in
            if let error = error {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            } else if let reviews = reviews {
                self.benchReviews = reviews
                self.showReviews = true
                
                if (reviews.count > 0) {
                    var total: Double = 0
                    for review in reviews {
                        total += review.rating
                    }
                    
                    self.averageRating = total / Double(reviews.count)
                }

                if reviews.count == 1 {
                    self.titleText = "1 review"
                } else {
                    self.titleText = "\(reviews.count) reviews"
                }
            }
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
