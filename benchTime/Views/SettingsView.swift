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
    @Environment(\.colorScheme) var colorScheme
    @State private var error: Error?
    @State private var user: UserModel?
    
    @State private var isConfirmingAction = false
    @State private var isDeleting = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                URLImage(URL(string: user.profileImageURL)!) { image in
                                   // Use the loaded image
                                   image
                                       .resizable()
                                       .aspectRatio(contentMode: .fill)
                               }
                               .frame(width: 64, height: 64)
                               .clipShape(Circle())
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
                        BTNavigationItem(icon: "person.circle", title: "Update account details", color: colorScheme == .dark ? UIStyles.Colors.Dark.label : UIStyles.Colors.Light.label)
                    }
                    
                    NavigationLink(destination: UpdatePasswordView()) {
                        BTNavigationItem(icon: "key", title: "Update password", color: colorScheme == .dark ? UIStyles.Colors.Dark.label : UIStyles.Colors.Light.label)
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
                                .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
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
                                .foregroundColor(UIStyles.Colors.red)
                                .bold()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(UIStyles.Colors.red)
                    .frame(height: 44, alignment: .leading)
                    
                    Spacer()
                        .frame(height: 24)
                }
                
                if (isDeleting) {
                    Loading()
                }
            }
            .padding()
        }
        .frame(alignment: .topLeading)
        .alert(isPresented: $isConfirmingAction) {
            Alert(
                title: Text("Confirm Action"),
                message: Text("Are you sure you want to delete your account and associated reviews?"),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        do {
                            isDeleting = true
                            
                            try await DatabaseAPI.shared.deleteUserAsync(uid: authManager.currentUser?.uid ?? "")
                            
                            try await authManager.deleteCurrentUserAsync()
                            
                            authManager.showSignInView = true
                            
                            isDeleting = false
                            
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
