//
//  MyReviewsView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI

struct MyReviewsView: View {
    @StateObject var myReviewsViewModel = MyReviewsViewViewModel()
    
    @Binding var toTop: Bool

    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .top) {
                    ScrollViewReader { proxy in
                        VStack(spacing: 0) {
                            if myReviewsViewModel.headerVisible {
                                HStack {
                                    Text("My reviews")
                                        .font(.headline)
                                        .onTapGesture {
                                            withAnimation {
                                                scrollToTop(proxy: proxy)
                                            }
                                        }
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 64)
                                .transition(.move(edge: .top))
                                .zIndex(1)
                            } else {
                                Spacer()
                            }
                            
                            ScrollView(showsIndicators: false) {
                                VStack {
                                    if myReviewsViewModel.showReviews, let reviews = myReviewsViewModel.currentUserReviews {
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
                                .padding(.top, 8)
                                .padding(.bottom)
                                .id("scrollToTop")
                            }
                            .coordinateSpace(name: "scrollView")
                            .refreshable {
                                print("Refreshing reviews...")
                                myReviewsViewModel.fetchReviews()
                            }
                        }
                        .onAppear {
                            myReviewsViewModel.fetchReviews()
                            scrollToTop(proxy: proxy)
                        }
                        .onChange(of: toTop) { _, _ in
                            withAnimation {
                                scrollToTop(proxy: proxy)
                            }
                        }
                    }
                }
            }
            .animation(.easeInOut, value: myReviewsViewModel.headerVisible)
        }
    }
}
