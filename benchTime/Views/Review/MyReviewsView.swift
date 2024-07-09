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
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack {
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
                        .id("scrollToTop")
                    }
                }
                .onAppear {
                    myReviewsViewModel.fetchReviews()
                    scrollToTop(proxy: proxy)
                }
            }
        }
    }
    
    func scrollToTop(proxy: ScrollViewProxy) {
        proxy.scrollTo("scrollToTop", anchor: .top)
    }
}
