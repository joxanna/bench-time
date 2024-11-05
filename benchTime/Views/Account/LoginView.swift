//
//  LoginView.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var authManager = AuthenticationManager.shared
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HeaderView()
                VStack {
                    BTFormField(label: "Email address", text:  $viewModel.email)
                    
                    BTSecureField(label: "Password", text:  $viewModel.password)

                    BTButton(title: "Take a seat", isDisabled: false) {
                        Task {
                            viewModel.login() { result in
                                switch result {
                                    case .success:
                                        print("Login successful")
                                        authManager.showSignInView = false
                                    case .failure:
                                        print("\(viewModel.errorMessage)")
                                }
                            }
                        }
                    }
                }

                .padding(25)
                
                VStack{
                    Text("New around here?")
                        
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Create an account")
                            .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
                            .font(.headline)
                    }
                }
                Spacer()
            }
            
            if (viewModel.isLoading) {
                Loading()
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

