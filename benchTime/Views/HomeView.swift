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
        VStack {
            if homeViewModel.headerVisible {
                HStack {
                    Image("BT")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                        .padding(.top, 8)
                }
                .frame(height: 64)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: homeViewModel.headerVisible)
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                    }
                    .frame(height: 0)
        
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
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                homeViewModel.updateHeaderVisibility(with: value)
            }
        }
        .onAppear {
            homeViewModel.fetchReviews()
        }
    }
}


struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
        print(value)
    }
}
