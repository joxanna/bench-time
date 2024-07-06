//
//  HomeViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 2/7/2024.
//

import SwiftUI

class HomeViewViewModel: ObservableObject {
    @ObservedObject var authManager = AuthenticationManager.shared
    
    @Published var currentReviews: [ReviewModel]?
    @Published var errorMessage: String?
    
    @Published var headerVisible: Bool = true
    @Published var lastScrollPosition: CGFloat = 0
    
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
