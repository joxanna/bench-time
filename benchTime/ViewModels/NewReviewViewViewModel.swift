//
//  NewReviewViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 20/5/2024.
//

import Foundation
import SwiftUI
import SwiftOverpassAPI

class NewReviewViewViewModel: ObservableObject {
    @Published var uid: String
    @Published var title = ""
    @Published var description = ""
    @Published var rating: Double = 0
    @Published var imageURLs: [String] = []
    @Published var benchId: String
    @Published var latitude: Double
    @Published var longitude: Double
    
    init(benchId: String, latitude: Double, longitude: Double) {
        uid = AuthenticationManager.shared.currentUser!.uid
        self.benchId = benchId
        self.latitude = latitude
        self.longitude = longitude
    }
      
    func createReview(completion: @escaping (Error?) -> Void) {
        guard !isEmpty() else {
            completion(NSError(domain: "BenchTime", code: 1001, userInfo: [NSLocalizedDescriptionKey: "New Review: Required fields are empty"]))
            return
        }
        
        let newReview = ReviewModel(uid: uid, benchId: benchId, title: title, description: description,
                                    rating: Double(rating), imageURLs: imageURLs, latitude: latitude, longitude: longitude)
        
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
    
    func isNotEmpty() -> Bool {
        return !title.isEmpty || !description.isEmpty || !imageURLs.isEmpty
    }

    
    private func reset() {
        title = ""
        description = ""
        rating = 0
        imageURLs = []
    }
    
    func clear() {
        // delete images if uploaded
        if !imageURLs.isEmpty {
            for image in imageURLs {
                DatabaseAPI.shared.deleteImageFromStorage(imageURL: image) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
       reset()
    }
}
