//
//  HomeView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewViewModel()
    @Binding var toTop: Bool
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                ScrollViewReader { proxy in
                    VStack(spacing: 0) {
                        if homeViewModel.headerVisible {
                            HStack {
                                Image("BT")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 56, height: 56)
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
                                if homeViewModel.showReviews, let reviews = homeViewModel.currentReviews {
                                    ForEach(reviews) { review in
                                        BTCard(review: review, currentUser: false, address: true) {
                                            homeViewModel.fetchReviews()
                                        }
                                        .padding()
                                    }
                                }
                            }
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onChange(of: geo.frame(in: .global).minY) { newValue, _ in
                                            homeViewModel.updateScrollPosition(offset: newValue)
                                        }
                                }
                            )
                            .padding(.top, 8)
                            .id("scrollToTop")
                        }
                        .coordinateSpace(name: "scrollView")
                        .refreshable {
                            homeViewModel.fetchReviews()
                        }
                    }
                    .onAppear {
                        print("APPEAR")
                        homeViewModel.fetchReviews()
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
        .animation(.easeInOut, value: homeViewModel.headerVisible)
    }
}

