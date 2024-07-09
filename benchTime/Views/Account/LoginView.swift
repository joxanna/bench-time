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
    
    var body: some View {
        ZStack {
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
                                        print("\(viewModel.errorMessage)")
                                }
                            }
                        }
                    }
                }
//<<<<<<< Updated upstream
//                if (errorMessage != "") {
//                    Text(errorMessage).foregroundColor(.red)
//=======
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
//>>>>>>> Stashed changes
                }
                Spacer()
            }
            
            if (viewModel.isLoading) {
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

