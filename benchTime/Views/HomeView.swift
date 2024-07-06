//
//  HomeView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
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
                            .onChange(of: geo.frame(in: .named("scrollView")).minY) { newValue, _ in
                                homeViewModel.updateScrollPosition(offset: newValue)
                            }
                    }
                )
                .padding(.top, 72)
            }
            .coordinateSpace(name: "scrollView")
            .onAppear {
                 // Disable bouncing
                 UIScrollView.appearance().bounces = false
             }
            
            if homeViewModel.headerVisible {
                HStack {
                    Image("BT")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                }
                .frame(width: UIScreen.main.bounds.width, height: 80)
                .background(.white)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onAppear {
            homeViewModel.fetchReviews()
        }
        .animation(.snappy, value: homeViewModel.headerVisible)
    }
}
