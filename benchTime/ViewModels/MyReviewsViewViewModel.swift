//
//  MyReviewsViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 6/7/2024.
//

import SwiftUI

class MyReviewsViewViewModel: ObservableObject {
    @ObservedObject var authManager = AuthenticationManager.shared
    
    @Published var currentUserReviews: [ReviewModel]?
    @Published var errorMessage: String?
    
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
  
//    func fetchReviews() async {
//        do {
//            // Fetch reviews asynchronously
//            guard let uid = authManager.currentUser?.uid else {
//                print("UID issue")
//                return
//            }
//            
//            let reviews = try await DatabaseAPI.shared.readReviewsByUser(uid: uid)
//            DispatchQueue.main.async {
//                self.currentUserReviews = reviews
//            }
//        } catch {
//            self.errorMessage = error.localizedDescription
//            print("Failed to fetch reviews: \(error.localizedDescription)")
//        }
//    }
//}
