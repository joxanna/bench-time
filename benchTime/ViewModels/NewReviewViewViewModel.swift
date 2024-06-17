//
//  NewReviewViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 20/5/2024.
//

import Foundation
import SwiftUI

class NewReviewViewViewModel: ObservableObject {
    @Published var uid: String
    @Published var title = ""
    @Published var description = ""
    @Published var rating: Double = 0
    @Published var imageURLs: [String] = []
    
    init() {
        uid = AuthenticationManager.shared.currentUser!.uid
    }
      
    func createReview(completion: @escaping (Error?) -> Void) {
        guard !isEmpty() else {
            completion(NSError(domain: "BenchTime", code: 1001, userInfo: [NSLocalizedDescriptionKey: "New Review: Required fields are empty"]))
            return
        }
        
        let newReview = ReviewModel(uid: uid, title: title, description: description, rating: Double(rating), imageURLs: imageURLs)
        
        DatabaseAPI.shared.createReview(review: newReview) { error in
            if let error = error {
                // Error saving review data to database
                print(error.localizedDescription)
                completion(error)
            } else {
                // Review data saved successfully
                completion(nil)
                self.reset()
            }
        }
    }
    
    func isEmpty() -> Bool {
        return title == "" || description == "" || imageURLs == []
    }
    
    func reset() {
        title = ""
        description = ""
        rating = 0
        imageURLs = []
    }
}
