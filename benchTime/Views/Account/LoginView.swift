//
//  LoginView.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @StateObject var viewModel = LoginViewViewModel()
    @State private var errorMessage: String = ""
    
    var body: some View {
        HeaderView()

        VStack {
            TextField("Email address", text: $viewModel.email, onCommit: {
                hideKeyboard()
            })
                .formFieldViewModifier()
            
            SecureField("Password", text: $viewModel.password, onCommit: {
                hideKeyboard()
            })
                .formFieldViewModifier()
            
            BTButton(title: "Take a seat", backgroundColor: Color.cyan) {
                Task {
                    viewModel.login() { result in
                        switch result {
                            case .success:
                                print("Login successful")
                                authManager.showSignInView = false
                            case .failure(let error):
                                switch error {
                                    case .invalidDetails:
                                        print("Invalid details: Please fill in all fields")
                                        errorMessage = "Invalid details: Please fill in all fields"
                                    case .detailsNotFound:
                                        print("Details not found")
                                    case .registrationFailed(let registrationError):
                                        print("Registration failed: \(registrationError.localizedDescription)")
                                        errorMessage = registrationError.localizedDescription
                                            
                                }
                        }
                    }
                }
            }
            if (errorMessage != "") {
                Text(errorMessage).foregroundColor(.red)
            }
        }
        .padding(25)
        
        VStack{
            Text("New around here?")
                
            NavigationLink {
                RegisterView()
            } label: {
                Text("Create an account")
                    .foregroundColor(.cyan)
                    .font(.headline)
            }
        }
        .padding(.bottom, 50)
    }
}
