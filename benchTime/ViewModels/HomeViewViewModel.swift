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
    @Published var lastOffset: CGFloat = 0
    
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
    
    func updateHeaderVisibility(with currentOffset: CGFloat) {
        if currentOffset < lastOffset {
            headerVisible = false
        } else if currentOffset > lastOffset {
            headerVisible = true
        } else if currentOffset <= 10 {
            headerVisible = true
        }
        lastOffset = currentOffset
        print(currentOffset)
    }
}
