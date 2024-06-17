//
//  MyReviewsView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI

struct MyReviewsView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var currentUserReviews: [ReviewModel]?
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            Text("My reviews")
                .font(.headline)
            VStack {
                if let reviews = currentUserReviews {
                    ForEach(reviews) { review in
                        BTCard(review: review, currentUser: true) {
                            fetchReviews()
                        }
                    }
                } else {
                    ProgressView() // Show loading indicator while reviews are being fetched
                }
            }
        }
        .onAppear {
            fetchReviews()
        }
    }
    
    func fetchReviews() {
        print("Fetching...")
        guard let uid = authManager.currentUser?.uid else {
            print("UID issue")
            return
        }
        
        DatabaseAPI.shared.readReviewsByUser(uid: uid) { reviews, error in
            if let error = error {
                // Handle the error
                self.errorMessage = error.localizedDescription
                print("Fail")
            } else if let reviews = reviews {
                // Assign currentUserReviews here
                self.currentUserReviews = reviews
                print("Success")
            }
        }
        
    }
}
