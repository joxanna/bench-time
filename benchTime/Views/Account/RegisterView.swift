//
//  RegisterView.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    @StateObject var viewModel = RegisterViewViewModel()
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            Spacer()
            HeaderView()
            VStack {
                BTFormField(label: "Display name", text:  $viewModel.displayName)
                
                BTFormField(label: "Email address", text:  $viewModel.email)
                
                BTSecureField(label: "Password", text:  $viewModel.password)

                BTButton(title: "Register", backgroundColor: Color.cyan) {
                    Task {
                        viewModel.register() { result in
                            switch result {
                                case .success:
                                    print("Login successful")
                                    authManager.showSignInView = false
                                case .failure(let error):
                                    switch error {
                                        case .invalidDetails:
                                            print("Invalid details")
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
                Text("Already have an account?")
                    
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Take a seat")
                        .foregroundColor(.cyan)
                        .font(.headline)
                }
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
