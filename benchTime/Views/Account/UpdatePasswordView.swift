//
//  UpdatePasswordView.swift
//  benchTime
//
//  Created by Joanna Xue on 17/5/2024.
//
import Foundation
import SwiftUI

struct UpdatePasswordView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isPasswordUpdated: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var isUpdating: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 32)
                
                BTSecureField(label: "Current password", text:  $currentPassword)
                
                BTSecureField(label: "New password", text:  $newPassword)
                
                Spacer()
                
                if (!errorMessage.isEmpty) {
                    Text(errorMessage)
                        .foregroundColor(UIStyles.Colors.red)
                        .padding()
                }
                
                if (isPasswordUpdated) {
                    Text("Password successfully updated!")
                        .foregroundColor(.green)
                        .padding()
                }
            }
            
            if isUpdating {
                Loading()
            }
        }
        .padding()
        .navigationBarTitle("Update password")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        if !isEmpty() {
                            showAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                        }
                    }
                }
                .padding(.leading, -10)
                .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if (!isEmpty()) {
                    NavigationLink(destination: SettingsView()) {
                        Button(action: {
                            isUpdating = true
                            authManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
                                if let error = error {
                                    errorMessage = error.localizedDescription
                                } else {
                                    isPasswordUpdated = true
                                    presentationMode.wrappedValue.dismiss()
                                    isUpdating = false
                                }
                            }
                        }) {
                            Text("Done")
                                .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
                                .bold()
                        }
                        .transition(.opacity)
                    }
                }
            }
        }
        .animation(.default, value: isEmpty())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want to discard changes?"),
                primaryButton: .destructive(Text("Discard")) {
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func isEmpty() -> Bool {
        if (!currentPassword.isEmpty && !newPassword.isEmpty) {
            return false
        }
        return true
    }
}
