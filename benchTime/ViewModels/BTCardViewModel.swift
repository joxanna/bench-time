//
//  BTCardViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 8/7/2024.
//

import SwiftUI

class BTCardViewModel: ObservableObject {
    @Published var ratingText: String = ""
    @Published var addressText: String = ""
    @Published var user: UserModel?
    @Published var isConfirmingAction = false
    @Published var isLoading = false
    
    let review: ReviewModel
    let onUpdate: () -> Void
    
    init(review: ReviewModel, onUpdate: @escaping () -> Void) {
        self.review = review
        self.onUpdate = onUpdate
        setup()
    }
    
    private func setup() {
        DispatchQueue.main.async {
            self.fetchUser()
            self.setupRatingText()
            self.fetchAddress()
        }
    }
    
    private func setupRatingText() {
        if review.rating.truncatingRemainder(dividingBy: 1) == 0 {
            ratingText = String(format: "(%.0f/5 stars)", review.rating)
        } else {
            ratingText = String(format: "(%.1f/5 stars)", review.rating)
        }
    }
    
    private func fetchUser() {
        if let uid = review.uid {
            DatabaseAPI.shared.readUser(uid: uid) { userDetails, error in
                if let error = error {
                    print("Read error: \(error.localizedDescription)")
                } else {
                    self.user = userDetails
                }
            }
        } else {
            print("No uid for review")
        }
    }
    
    private func fetchAddress() {
        if review.latitude != 0 && review.longitude != 0 {
            getAddress(latitude: review.latitude, longitude: review.longitude) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    self.addressText = "No address"
                } else if let result = result {
                    self.addressText = result
                }
            }
        } else {
            self.addressText = "No address"
        }
    }
    
    func deleteReview() {
        DispatchQueue.main.async {
            Task {
                self.isLoading = true
                try await DatabaseAPI.shared.deleteReview(id: self.review.id!) { error in
                    if let error = error {
                        self.isLoading = false
                        print("Deleting failed: \(error.localizedDescription)")
                    } else {
                        print("Delete successful")
                        self.isLoading = false
                        self.onUpdate()
                        print("Refreshing...")
                    }
                }
            }
        }
    }
}
