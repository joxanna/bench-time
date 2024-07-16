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

    var body: some View {
        ZStack {
            TabView(selection: $rootViewModel.selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .padding(.top, 10)
                    .tag(0)  // Tag for the Home tab
                
                SearchBenchesView()
                    .environmentObject(rootViewModel.searchQueryViewModel)  // Pass the view model to the tab
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .padding(.top, 10)
                    .tag(1)  // Tag for the SearchBenchesView tab
                
                MyReviewsView()
                    .tabItem {
                        Label("My reviews", systemImage: "chair")
                    }
                    .padding(.top, 10)
                    .tag(2)  // Tag for the MyReviews tab
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .padding(.top, 10)
                    .tag(3)  // Tag for the Settings tab
            }
            .onChange(of: rootViewModel.selectedTab) { newValue, _ in
                if newValue == 1 {  // Switch to SearchBenchesView tab
                    rootViewModel.searchQueryViewModel.searchText = rootViewModel.searchQueryViewModel.searchText
                }
            }
            .fullScreenCover(isPresented: $authManager.showSignInView) {
                NavigationStack {
                    LoginView()
                }
            }
        }
        .environmentObject(rootViewModel)  // Provide RootViewModel to the environment
    }
}
