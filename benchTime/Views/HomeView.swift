//
//  HomeView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var currentReviews: [ReviewModel]?
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            Text("Home Page")
                .font(.headline)
            VStack {
                if let reviews = currentReviews {
                    ForEach(reviews) { review in
                        BTCard(review: review, currentUser: false, address: true) {
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
        
        DatabaseAPI.shared.readAllReviews(uid: uid) { reviews, error in
            if let error = error {
                // Handle the error
                self.errorMessage = error.localizedDescription
                print("Fail")
            } else if let reviews = reviews {
                // Assign currentUserReviews here
                self.currentReviews = reviews
                print("Success")
            }
        }
        
    }
}
