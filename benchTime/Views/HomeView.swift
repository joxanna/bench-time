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
                            .background(Color.white)
                            .transition(.move(edge: .top))
                            .zIndex(1)
                        }
                        
                        ScrollView(showsIndicators: false) {
                            VStack {
                                if let reviews = homeViewModel.currentReviews {
                                    ForEach(reviews) { review in
                                        BTCard(review: review, currentUser: false, address: true) {
                                            homeViewModel.fetchReviews()
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
                                            homeViewModel.updateScrollPosition(offset: newValue)
                                        }
                                }
                            )
                            .padding(.top, 8)
                            .padding(.bottom)
                            .id("scrollToTop")
                        }
                        .coordinateSpace(name: "scrollView")
                        .refreshable {
                            homeViewModel.fetchReviews()
                        }
                    }
                    .onAppear {
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

//
//
//
//struct HomeView: View {
//    @State private var isShowingFullScreenCover = false
//
//    var body: some View {
//        Button("Show Full Screen Cover") {
//            isShowingFullScreenCover.toggle()
//        }
//        .fullScreenCover(isPresented: $isShowingFullScreenCover) {
//            // Pass any content you want to display
//            FullScreenCoverView {
//                Text("Hello")
//            }
//        }
//    }
//}
