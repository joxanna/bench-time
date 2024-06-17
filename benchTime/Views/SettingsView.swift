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
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = authManager.currentUserDetails {
                    // Display user details
                    Text("Email: \(user.email)")
                    Text("Display Name: \(user.displayName)")
                    
                    if user.profileImageURL != "" {
                        URLImage(URL(string: user.profileImageURL)!) { image in
                           // Use the loaded image
                           image
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                       }
                       .frame(width: 100, height: 100) // Adjust size as needed
                    } else {
                        Text("No Profile Image")
                    }
                } else if let error = error {
                    // Display error
                    Text("Error: \(error.localizedDescription)")
                } else {
                    // Display loading state
                    Text("Loading user details...")
                }
                
                List {
                    NavigationLink(destination: UpdateAccountDetailsView()) {
                        Text("Update Account Details")
                    }
                    
                    NavigationLink(destination: UpdatePasswordView()) {
                        Text("Update Password")
                    }
                    
                    Button("Stand up") {
                        Task {
                            authManager.signOut() { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                    .foregroundColor(.cyan)
                    
                    Button("Delete Account") {
                        isConfirmingAction.toggle()
                    }
                    .foregroundColor(.red)
                }
                .navigationBarTitle("Settings")
            }
        }
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

