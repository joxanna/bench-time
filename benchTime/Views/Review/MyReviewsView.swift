//
//  MyReviewsView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI

struct MyReviewsView: View {
    @ObservedObject var myReviewsViewModel = MyReviewsViewViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("My reviews")
                        .font(.headline)
                }
                .frame(height: 64)
                
                VStack {
                    if let reviews = myReviewsViewModel.currentUserReviews {
                        ForEach(reviews) { review in
                            BTCard(review: review, currentUser: true, address: true) {
                                myReviewsViewModel.fetchReviews()
                            }
                            .padding()
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            myReviewsViewModel.fetchReviews()
        }
    }
}
