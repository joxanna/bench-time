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
    
    func updateReview(id: String, completion: @escaping (Error?) -> Void) {
        let newData = ReviewModel(title: title, description: description, rating: rating)
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
    }
}
