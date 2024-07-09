//
//  ContentView.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var selectedTab = 0 // HomeView tab index

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0) // Tag for HomeView
                
                SearchBenchesView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(1) // Tag for SearchBenchesView
                
                MyReviewsView()
                    .tabItem {
                        Label("My reviews", systemImage: "chair")
                    }
                    .tag(2) // Tag for MyReviewsView
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(3) // Tag for SettingsView
            }
        }
        .fullScreenCover(isPresented: $authManager.showSignInView) {
            NavigationStack {
                LoginView()
            }
        }
        .onChange(of: authManager.showSignInView) { newValue, _ in
            if !newValue {
                selectedTab = 0
            }
        }
    }
}
