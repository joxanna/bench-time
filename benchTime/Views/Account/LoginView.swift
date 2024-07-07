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
        VStack {
            Spacer()
            HeaderView()
            
            VStack {
                BTFormField(label: "Email address", text:  $viewModel.email)
                
                BTSecureField(label: "Password", text:  $viewModel.password)

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
                .alert(isPresented: .constant(!errorMessage.isEmpty)) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
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
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
