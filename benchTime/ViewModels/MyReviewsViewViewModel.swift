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
    @Published var showReviews: Bool = false
    
    @Published var headerVisible: Bool = true
    @Published var lastScrollPosition: CGFloat = 0
    
    func fetchReviews() {
        print("Fetching in my reviews...")
        guard let uid = authManager.currentUser?.uid else {
            print("UID issue")
            return
        }
        
        showReviews = false
        
        DatabaseAPI.shared.readReviewsByUser(uid: uid) { [weak self] reviews, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Handle the error
                    self?.errorMessage = error.localizedDescription
                    print("Fail: \(error.localizedDescription)")
                } else if let reviews = reviews {
                    // Assign currentUserReviews here
                    self?.currentUserReviews = reviews
                    self?.showReviews = true
                    print("Success")
                }
            }
        }
    }
    
    func updateScrollPosition(offset: CGFloat) {
        if offset >= 0 {
            self.headerVisible = true
        } else if offset > lastScrollPosition {
            headerVisible = true
        } else if offset < lastScrollPosition {
            headerVisible = false
        }
        lastScrollPosition = offset
    }
}
