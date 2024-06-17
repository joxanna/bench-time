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
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var isPasswordUpdated: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                SecureField("Current password", text: $currentPassword, onCommit: {
                    hideKeyboard()
                })
                    .formFieldViewModifier()
                
                SecureField("New password", text: $newPassword, onCommit: {
                    hideKeyboard()
                })
                    .formFieldViewModifier()
                
                BTButton(title: "Update password", backgroundColor: Color.cyan) {
                    Task {
                        authManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                isPasswordUpdated = true
                            }
                        }
                    }
                }
                
                if (!errorMessage.isEmpty) {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                
                if (isPasswordUpdated) {
                    Text("Password successfully updated!")
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .padding(25)
        .navigationBarTitle("Update Password")
    }
}

struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdatePasswordView()
        }
    }
}

