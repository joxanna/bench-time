//
//  SettingsView.swift
//  benchTime
//
//  Created by Joanna Xue on 9/5/2024.
//

import SwiftUI
import FirebaseAuth
import URLImage

struct SettingsView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var error: Error?
    @State private var user: UserModel?
    
    @State private var isConfirmingAction = false
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
//<<<<<<< Updated upstream
//        NavigationView {
//            VStack(alignment: .leading) {
//                Spacer()
//                    .frame(height: 32)
//                
//                Text("Profile")
//                    .font(.title2)
//                    .bold()
//                HStack {
//                    if let user = authManager.currentUserDetails {
//                        // Display user details
//                        if user.profileImageURL != "" {
//                            URLImage(URL(string: user.profileImageURL)!) { image in
//                               // Use the loaded image
//                               image
//                                   .resizable()
//                                   .aspectRatio(contentMode: .fill)
//                           }
//                           .frame(width: 64, height: 64)
//                           .clipShape(Circle())
//                        } else {
//                            Image("no-profile-image")
//=======
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 32)
            
            Text("Profile")
                .font(.title2)
                .bold()
            HStack {
                if let user = authManager.currentUserDetails {
                    // Display user details
                    if user.profileImageURL != "" {
                        AsyncImage(url: URL(string: user.profileImageURL)) { image in
                            image
//>>>>>>> Stashed changes
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image("no-profile-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    }
                    Spacer()
                        .frame(width: 16)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Display name:")
                                .font(.subheadline)
                                .bold()
                            Text("\(user.displayName)")
                                .font(.subheadline)
                        }
                        Spacer()
                            .frame(height: 8)
                        HStack {
                            Text("Email:")
                                .font(.subheadline)
                                .bold()
                            Text("\(user.email)")
                                .font(.subheadline)
                        }
                    }
                } else if let error = error {
                    // Display error
                    Text("Error: \(error.localizedDescription)")
                }
            }
            .padding(.leading, 8)
            
            Spacer()
                .frame(height: 32)
            
            Text("Settings")
                .font(.title2)
                .bold()
            
            NavigationLink(destination: UpdateAccountDetailsView()) {
                BTNavigationItem(icon: "person.circle", title: "Update account details", color: .black)
            }
            
            NavigationLink(destination: UpdatePasswordView()) {
                BTNavigationItem(icon: "key", title: "Update password", color: .black)
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    authManager.signOut() { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }) {
                HStack {
                    Text("Stand up")
                        .foregroundColor(.cyan)
                        .bold()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 44, alignment: .leading)
            
            Button(action: {
                isConfirmingAction.toggle()
            }) {
                HStack {
                    Text("Delete account")
                        .foregroundColor(.red)
                        .bold()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(.red)
            .frame(height: 44, alignment: .leading)
            
            Spacer()
                .frame(height: 24)
        }
        .padding()
        .frame(alignment: .topLeading)
        .alert(isPresented: $isConfirmingAction) {
            Alert(
                title: Text("Confirm Action"),
                message: Text("Are you sure you want to delete your account?"),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        do {
                            try await DatabaseAPI.shared.deleteUserAsync(uid: authManager.currentUser?.uid ?? "")
                            
                            try await authManager.deleteCurrentUserAsync()
                            
                            authManager.showSignInView = true
                            
                            print("Delete successful")
                        } catch {
                            print("Deleting failed: \(error.localizedDescription)")
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}