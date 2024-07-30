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
    
    var body: some View {
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
        .padding()
        .navigationBarTitle("Update password")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (!isEmpty()) {
                    NavigationLink(destination: SettingsView()) {
                        Button(action: {
                            authManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
                                if let error = error {
                                    errorMessage = error.localizedDescription
                                } else {
                                    isPasswordUpdated = true
                                    presentationMode.wrappedValue.dismiss()
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
    }
    
    func isEmpty() -> Bool {
        if (!currentPassword.isEmpty && !newPassword.isEmpty) {
            return false
        }
        return true
    }
}
