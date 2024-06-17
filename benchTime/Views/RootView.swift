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
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .padding(.top, 10)
                
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .padding(.top, 10)
                
                MyReviewsView()
                    .tabItem {
                        Label("My reviews", systemImage: "chair")
                    }
                    .padding(.top, 10)
                
                NewReviewView()
                    .tabItem {
                        Label("New review", systemImage: "pencil")
                    }
                    .padding(.top, 10)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .padding(.top, 10)
            }
            
        }
        .fullScreenCover(isPresented: $authManager.showSignInView) {
            NavigationStack {
                LoginView()
            }
        }
    }
}
