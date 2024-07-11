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
                VStack {
                    if myReviewsViewModel.headerVisible {
                        HStack {
                            Text("My reviews")
                                .font(.headline)
                        }
                        .onTapGesture {
                            withAnimation {
                                scrollToTop(proxy: proxy)
                                print("TO THE TOP")
                            }
                        }
                        .frame(height: 64)
                        .transition(.move(edge: .top))
                        .zIndex(1)
                    }
                    
                    ScrollView(showsIndicators: false) {
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
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onChange(of: geo.frame(in: .global).minY) { newValue, _ in
                                        myReviewsViewModel.updateScrollPosition(offset: newValue)
                                    }
                            }
                        )
                        .id("scrollToTop")
                    }
                    .refreshable {
                        myReviewsViewModel.fetchReviews()
                    }
                }
                .onAppear {
                    myReviewsViewModel.fetchReviews()
                    scrollToTop(proxy: proxy)
                }
                .animation(.easeInOut, value: myReviewsViewModel.headerVisible)
            }
        }
    }
}
