//
//  ContentView.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @StateObject private var rootViewModel = RootViewViewModel()
    @ObservedObject var authManager = AuthenticationManager.shared

    @State private var scrollToTopHome = false
    @State private var scrollToTopMyReviews = false

    var body: some View {
        ZStack {
            TabView(selection: $rootViewModel.selectedTab) {
                Group {
                    HomeView(toTop: $scrollToTopHome)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(0)
                    
                    SearchBenchesView()
                        .environmentObject(rootViewModel.searchQueryViewModel)
                        .tabItem {
                            Label("Map", systemImage: "map")
                        }
                        .tag(1)
                    
                    MyReviewsView(toTop: $scrollToTopMyReviews)
                        .tabItem {
                            Label("My reviews", systemImage: "chair")
                        }
                        .tag(2)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        .tag(3)
                }
                .toolbarBackground(.white, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
            .onChange(of: rootViewModel.selectedTab) { oldValue, newValue in
                if newValue == 1 {
                    rootViewModel.searchQueryViewModel.searchText = rootViewModel.searchQueryViewModel.searchText
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<4) { index in
                        Button(action: {
                            if rootViewModel.selectedTab == index {
                                if index == 0 {
                                    scrollToTopHome.toggle()
                                } else if index == 2 {
                                    scrollToTopMyReviews.toggle()
                                }
                            } else {
                                rootViewModel.selectedTab = index
                            }
                        }) {
                            Color.clear
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(height: 50)
            }
        }
        .environmentObject(rootViewModel)
        .fullScreenCover(isPresented: $authManager.showSignInView) {
            NavigationStack {
                LoginView()
            }
        }
    }
}
