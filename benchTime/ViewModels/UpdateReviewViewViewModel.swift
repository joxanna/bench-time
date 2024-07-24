//
//  UpdateReviewViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import Foundation

class UpdateReviewViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var rating: Double = 0
    @Published var review: ReviewModel
    
    init(review: ReviewModel) {
        self.review = review
    }
      
    func updateReview(completion: @escaping (Error?) -> Void) {
        let newData = ReviewModel(title: title, description: description, rating: rating)
        if let id = review.id {
            DatabaseAPI.shared.updateReview(id: id, newData: newData) { error in
                if let error = error {
                    // Error updating review data to database
                    print(error.localizedDescription)
                    completion(error)
                } else {
                    // Review data updated successfully
                    completion(nil)
                }
            }
        } else {
            print("Invalid review ID")
        }
    }
    
    func isEmpty() -> Bool {
        if title.isEmpty || description.isEmpty {
            return true
        }
        
        if title != review.title || description != review.description || rating != review.rating {
            return false
        }
        
        return true
    }
    
    func isNotEmpty() -> Bool {
        return title != review.title || description != review.description || rating != review.rating
    }
    
    func reset() {
        self.title = review.title
        self.description = review.description
        self.rating = review.rating
    }
}
